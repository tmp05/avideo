import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/enums/studios.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';

class StudioFilter extends StatefulWidget {
  const StudioFilter({Key key, this.section}) : super(key: key);

  final String section;

  @override
  StudioFilterState createState() {
    return StudioFilterState();
  }
}

class StudioFilterState extends State<StudioFilter> {
  List<String> reportList = List();
  List<String> selectedReportList = List();

  List<Studios> reportStudiosList = List();
  List<Studios> selectedStudiosReportList = List();

  MovieFilters _currentFilter;

  _setStudio(MovieCatalogBloc _movieBloc) {
    setState(() {
      if (selectedReportList.isNotEmpty) {
        selectedStudiosReportList.clear();
        selectedReportList.forEach((element) {
          selectedStudiosReportList.add(
              reportStudiosList.firstWhere((Studios g) => g.text == element));
        });
        _currentFilter.studio = selectedStudiosReportList;
        _movieBloc.inFilters.add(_currentFilter);
      }
    });
  }

  _clearStudio(MovieCatalogBloc _movieBloc) {
    setState(() {
      _currentFilter.studio= List<Studios>();
      _movieBloc.inFilters.add(_currentFilter);
    });
  }


  _showReportDialog(String text, MovieCatalogBloc _movieBloc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text(text),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              InkWell(
                child: const Text(Constants.okText),
                onTap: () {
                  _setStudio(_movieBloc);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String convertStudiosToString(List<Studios> data) {
    List<String> stringList = List();
    data.forEach((element) {
      stringList.add(element.text);
    });
    return stringList.join(" , ");
  }

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
    BlocProvider.of<MovieCatalogBloc>(context);

    return Row(
      children: <Widget>[
        StreamBuilder<MovieFilters>(
            stream: movieBloc.outFilters,
            builder:
                (BuildContext context, AsyncSnapshot<MovieFilters> snapshot) {
              if (snapshot.data != null)
                _currentFilter = MovieFilters(
                  minReleaseDate: snapshot.data.minReleaseDate,
                  maxReleaseDate: snapshot.data.maxReleaseDate,
                  genre: snapshot.data.genre,
                  year: snapshot.data.year,
                  country: snapshot.data.country,
                  studio: snapshot.data.studio,
                  sort: snapshot.data.sort,
                );
              return       Flexible(
                  child: InkWell(
                    child: Text(
                      snapshot.data == null || snapshot.data.studio == null || snapshot.data.studio.length==0
                          ? Constants.studioFilterText
                          : convertStudiosToString(snapshot.data.studio),
                      style: Constants.StyleFilterTextUnderline,
                    ),
                    onTap: () {
                      AtotoApi().movieStudios(widget.section).then((value) => {
                        reportList.clear(),
                        reportStudiosList.clear(),
                        setState(() {
                          value.studios.forEach((element) {
                            reportList.add(element.text);
                            reportStudiosList.add(element);
                          });
                        }),
                        _showReportDialog(Constants.studioTitleFilterText, movieBloc)
                      });
                    },
                  ));
            }),
        InkWell(
            child:
            const Icon(Icons.clear, color: Constants.darkBlueColor),
            onTap: () {
              _clearStudio(movieBloc);
            }),
      ],
    );
  }
}
