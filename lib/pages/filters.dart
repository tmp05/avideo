import 'package:avideo/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as rnslider;
import 'package:avideo/blocs/application_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/filters.dart';
import 'package:avideo/models/enums/genre.dart';

typedef FiltersPageCallback = Function(MovieFilters result);

class FiltersPage extends StatefulWidget {
  const FiltersPage({
    Key key,
  }) : super(key: key);


  @override
  FiltersPageState createState() {
    return FiltersPageState();
  }
}

class FiltersPageState extends State<FiltersPage> {
  ApplicationBloc _appBloc;
  MovieCatalogBloc _movieBloc;
  double _minReleaseDate = 2000;
  double _maxReleaseDate=2019;

  bool _isInit = false;
  MovieFilters currentFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // As the context of not yet available at initState() level,
    // if not yet initialized, we get the list of all genres
    // and retrieve the currently selected one, as well as the
    // filter parameters
    if (_isInit == false){
      _appBloc = BlocProvider.of<ApplicationBloc>(context);
      _movieBloc = BlocProvider.of<MovieCatalogBloc>(context);
      _getFilterParameters();
    }
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
            StreamBuilder<List<Genre>>(
              stream: _appBloc.outMovieGenres,
              builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot){
                if (snapshot.data==null)
                  return Container();
                else
                  return  DropdownButton<Genre>(
                      value: currentFilter!=null?currentFilter.genre:null,
                      hint: const Text(Constants.genreFilterText),
                      items: snapshot.data.map((Genre genre) {
                        return DropdownMenuItem<Genre>(
                          value: genre,
                          child: Text(genre.title),
                        );
                      }).toList(),
                      onChanged: (Genre newMovieGenre) {
                        if (currentFilter.genre!=newMovieGenre) {
                          setState(() {
                            currentFilter.genre = newMovieGenre;
                          });
                        }
                      });
              },
            ),
            DropdownButton<SortItem>(
              onChanged: (SortItem value) {
                if (currentFilter.sort!=value) {
                  setState(() {
                    currentFilter.sort = value;
                  });
                }
              },
              value: currentFilter!=null?currentFilter.sort:null,
              hint: const Text(Constants.sortText),
              items: Constants.sortItems.map((SortItem item) {
                return  DropdownMenuItem<SortItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 5,),
                      Text(item.name,style:  const TextStyle(color: Constants.blackColor)),
                    ],
                  ),
                );
              }).toList(),
            ),
            Container(height: 10,),
            const Text(
              'Years:',
              style: TextStyle(decoration: TextDecoration.underline),
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
                        activeTrackColor: Constants.lightBlueColor,
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: rnslider.RangeSlider(
                        min: 2000.0,
                        max: 2019.0,
                        lowerValue: _minReleaseDate,
                        upperValue: _maxReleaseDate,
                        divisions: 18,
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 0,
                        onChanged: (double lower, double upper) {
                          setState(() {
                            _minReleaseDate = lower;
                            _maxReleaseDate = upper;
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
                    child: Text('${_maxReleaseDate.toStringAsFixed(0)}'),
                  ),
                ],
              ),
            ),

            const Divider(),
           // Genre Selector


          ],
        ),
      ),

      // Filters acceptance

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          _movieBloc.inFilters.add(currentFilter);
          // close the screen
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
    _movieBloc.outFilters.listen((MovieFilters filters){
      currentFilter =  MovieFilters(
          minReleaseDate: filters.minReleaseDate,
          maxReleaseDate: filters.maxReleaseDate,
          sort: filters.sort,
          genre: filters.genre);
    });
    // Now that we have all parameters, we may build the actual page
    if (mounted){
      setState((){
        _isInit = true;
      });
    }
  }
}