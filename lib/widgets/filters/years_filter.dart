import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/filters.dart';
import 'package:avideo/widgets/filters/adds.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';

class YearFilter extends StatefulWidget {
  const YearFilter({Key key, this.section, this.movieBloc}) : super(key: key);

  final String section;
  final MovieCatalogBloc movieBloc;

  @override
  YearFilterState createState() {
    return YearFilterState();
  }
}

class YearFilterState extends State<YearFilter> {
  int yearNow = DateTime.now().year;
  MovieFilters _currentFilter;
  RangeValues _values;
  String yearText = Constants.yearText;
  List<String> lastYearsList = List();

  @override
  void initState() {
    for (int i = yearNow; i > yearNow - 5; i--) {
      lastYearsList.add(i.toString());
    }

    super.initState();
  }

  _clearYears() {
    setState(() {
      yearText = Constants.yearText;
      _currentFilter.maxReleaseDate = null;
      _currentFilter.minReleaseDate = null;
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieFilters>(
        stream: widget.movieBloc.outFilters,
        builder: (BuildContext context, AsyncSnapshot<MovieFilters> snapshot) {
          if (snapshot.data != null)
            _currentFilter = Adds().copyFilter(snapshot.data);

          if (_currentFilter != null &&
              _currentFilter.minReleaseDate != null &&
              _currentFilter.maxReleaseDate != null) {
            yearText = _currentFilter.minReleaseDate.toString() +
                ' - ' +
                _currentFilter.maxReleaseDate.toString();
          }


          _values = RangeValues(
              _currentFilter == null || _currentFilter.minReleaseDate == null
                  ? 1910.0
                  : _currentFilter.minReleaseDate.toDouble(),
              _currentFilter == null || _currentFilter.maxReleaseDate == null
                  ? yearNow.toDouble()
                  : _currentFilter.maxReleaseDate.toDouble());

          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        decoration: new BoxDecoration(
                          color: Constants.lightBlueColor,
                          borderRadius: new BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          border: new Border.all(
                              color: Color.fromRGBO(0, 0, 0, 0.0)),
                        ),
                        child: Chip(
                          labelPadding: EdgeInsets.all(2.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          label: Text(
                            yearText,
                            style: Constants.StyleFilterText,
                          ),
                        )),
                    InkWell(
                        child: const Icon(Icons.clear,
                            color: Constants.darkBlueColor),
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
                        _currentFilter.minReleaseDate =
                            int.parse(selectedList[0]);
                        _currentFilter.maxReleaseDate =
                            int.parse(selectedList[selectedList.length - 1]);
                        yearText = _currentFilter.minReleaseDate.toString() +
                            ' - ' +
                            _currentFilter.maxReleaseDate.toString();
                      } else {
                        _currentFilter.minReleaseDate = 1910;
                        _currentFilter.maxReleaseDate = yearNow;
                        yearText = Constants.yearText;
                      }
                    });
                    widget.movieBloc.inFilters.add(_currentFilter);
                  },
                ),
                Container(
                    width: MediaQuery.of(context).size.width > 400
                        ? 400
                        : MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Constants.darkBlueColor,
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Constants.darkBlueColor,
                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: RangeSlider(
                              min: 1910.0,
                              max: yearNow.toDouble(),
                              values: _values,
                              divisions: yearNow - 1910,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  yearText = values.start.toInt().toString() +
                                      ' - ' +
                                      values.end.toInt().toString();
                                  _currentFilter.minReleaseDate =
                                      values.start.toInt();
                                  _currentFilter.maxReleaseDate =
                                      values.end.toInt();
                                });
                                widget.movieBloc.inFilters.add(_currentFilter);
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
                              '${_currentFilter == null || _currentFilter.maxReleaseDate == null ? yearNow.toStringAsFixed(0) : _currentFilter.maxReleaseDate.toStringAsFixed(0)}'),
                        ),
                      ],
                    ))
              ]);
        });
  }
}
