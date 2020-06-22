import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/studios.dart';
import 'package:avideo/widgets/filters/genre_filtre.dart';
import 'package:avideo/widgets/filters/sort_item.dart';
import 'package:avideo/widgets/filters/studio_filter.dart';
import 'package:avideo/widgets/multi_select_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart'
    as rnslider; //take it away!! https://medium.com/flutter/material-range-slider-in-flutter-a285c6e3447d
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/filters.dart';
import 'package:avideo/models/enums/genre.dart';

typedef FiltersPageCallback = Function(MovieFilters result);

class FiltersPage extends StatefulWidget {
  const FiltersPage({
    Key key,
    this.section,
  }) : super(key: key);

  final String section;

  @override
  FiltersPageState createState() {
    return FiltersPageState();
  }
}

class FiltersPageState extends State<FiltersPage> {
  MovieCatalogBloc _movieBloc;
  int yearNow = DateTime.now().year;

  bool _isInit = false;
  MovieFilters currentFilter;

  List<Map<String, List<String>>> dataList;

  List<String> reportList = List();
  List<String> selectedReportList = List();

  List<Genre> reportGenreList = List();
  List<Genre> selectedGenreReportList = List();
  String genreText = Constants.genreFilterText;

  List<Studios> reportStudioList = List();
  List<Studios> selectedStudioReportList = List();
  String studioText = Constants.studioFilterText;

  List<String> lastYearsList = List();
  String yearText = Constants.yearText;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // As the context of not yet available at initState() level,
    // if not yet initialized, we get the list of all genres
    // and retrieve the currently selected one, as well as the
    // filter parameters
    if (_isInit == false) {
      _movieBloc = BlocProvider.of<MovieCatalogBloc>(context);
      _getFilterParameters();
    }
  }




  _clearYears() {
    setState(() {
      yearText = Constants.yearText;
      currentFilter.maxReleaseDate = null;
      currentFilter.minReleaseDate = null;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Filters'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StudioFilter(section:widget.section,movieBloc: _movieBloc,),
            Container(
              height: 10,
            ),
            GenreFilter(section:widget.section,movieBloc: _movieBloc,),
            Container(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  yearText,
                  style: Constants.StyleFilterText,
                ),
                InkWell(
                    child:
                        const Icon(Icons.clear, color: Constants.darkBlueColor),
                    onTap: () {
                      _clearYears();
                    }),
              ],
            ),
            MultiSelectChip(
              lastYearsList,
              List(),
              onSelectionChanged: (selectedList) {
                setState(() {
                  if (selectedList.isNotEmpty) {
                    selectedList.sort();
                    currentFilter.minReleaseDate = int.parse(selectedList[0]);
                    currentFilter.maxReleaseDate =
                        int.parse(selectedList[selectedList.length - 1]);
                    yearText = currentFilter.minReleaseDate.toString() +
                        ' - ' +
                        currentFilter.maxReleaseDate.toString();
                  } else {
                    currentFilter.minReleaseDate = 1910;
                    currentFilter.maxReleaseDate = yearNow;
                    yearText = Constants.yearText;
                  }
                });
              },
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SliderTheme(
                      // Customization of the SliderTheme
                      // based on individual definitions
                      // (see rangeSliders in _RangeSliderSampleState)
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.darkBlueColor,
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.darkBlueColor,
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: rnslider.RangeSlider(
                        min: 1910.0,
                        max: yearNow.toDouble(),
                        lowerValue: currentFilter == null ||
                                currentFilter.minReleaseDate == null
                            ? 1910
                            : currentFilter.minReleaseDate.toDouble(),
                        upperValue: currentFilter == null ||
                                currentFilter.maxReleaseDate == null
                            ? yearNow.toDouble()
                            : currentFilter.maxReleaseDate.toDouble(),
                        divisions: yearNow - 1910,
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 0,
                        onChanged: (double lower, double upper) {
                          setState(() {
                            yearText = lower.toInt().toString() +
                                ' - ' +
                                upper.toInt().toString();
                            currentFilter.minReleaseDate = lower.toInt();
                            currentFilter.maxReleaseDate = upper.toInt();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 40.0,
                      maxWidth: 40.0,
                    ),
                    child: Text(
                        '${currentFilter == null || currentFilter.maxReleaseDate == null ? yearNow.toStringAsFixed(0) : currentFilter.maxReleaseDate.toStringAsFixed(0)}'),
                  ),
                ],
              ),
            ),
           SortItemWidget()
            // Genre Selector
          ],
        ),
      ),

      // Filters acceptance

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  ///
  /// Very tricky.
  ///
  /// As we want to be 100% BLoC compliant, we need to retrieve
  /// everything from the BLoCs, using Streams...
  ///
  /// This is ugly but to be considered as a study case.
  ///
  void _getFilterParameters() {
    for (int i = yearNow; i > yearNow - 5; i--) {
      lastYearsList.add(i.toString());
    }
    _movieBloc.outFilters.listen((MovieFilters filters) {
      currentFilter = MovieFilters(
          minReleaseDate: filters.minReleaseDate,
          maxReleaseDate: filters.maxReleaseDate,
          sort: filters.sort,
          genre: filters.genre,
          studio: filters.studio);
      if (mounted) {
        setState(() {
          if (currentFilter.genre != null) {
            selectedReportList.clear();
            currentFilter.genre.forEach((element) {
              selectedReportList.add(element.text);
            });
            genreText = selectedReportList.isNotEmpty
                ? selectedReportList.join(" , ")
                : Constants.genreFilterText;
          }

          if (currentFilter.studio != null) {
            selectedReportList.clear();
            currentFilter.studio.forEach((element) {
              selectedReportList.add(element.text);
            });
            studioText = selectedReportList.isNotEmpty
                ? selectedReportList.join(" , ")
                : Constants.studioFilterText;
          }
          if (currentFilter.minReleaseDate != null &&
              currentFilter.maxReleaseDate != null) {
            yearText = currentFilter.minReleaseDate.toString() +
                ' - ' +
                currentFilter.maxReleaseDate.toString();
          }
        });
      }
    });

    if (mounted) {
      setState(() {
        _isInit = true;
      });
    }
  }
}
