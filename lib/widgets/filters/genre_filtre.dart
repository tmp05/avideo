import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';

class GenreFilter extends StatefulWidget {
  const GenreFilter({Key key, this.section}) : super(key: key);

  final String section;

  @override
  GenreFilterState createState() {
    return GenreFilterState();
  }
}

class GenreFilterState extends State<GenreFilter> {
  List<String> reportList = List();
  List<String> selectedReportList = List();

  List<Genre> reportGenreList = List();
  List<Genre> selectedGenreReportList = List();

  MovieFilters _currentFilter;

  _clearGenre(MovieCatalogBloc _movieBloc) {
    setState(() {
      _currentFilter.genre= List<Genre>();
      _movieBloc.inFilters.add(_currentFilter);
    });
  }

  _setGenre(MovieCatalogBloc _movieBloc) {
    setState(() {
      if (selectedReportList.isNotEmpty) {
        selectedGenreReportList.clear();
        selectedReportList.forEach((element) {
          selectedGenreReportList
              .add(reportGenreList.firstWhere((Genre g) => g.text == element));
        });
        _currentFilter.genre = selectedGenreReportList;
        _movieBloc.inFilters.add(_currentFilter);
      }
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
                  _setGenre(_movieBloc);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String convertGenresToString(List<Genre> data) {
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
                    snapshot.data == null || snapshot.data.genre == null || snapshot.data.genre.length==0
                        ? Constants.genreFilterText
                        : convertGenresToString(snapshot.data.genre),
                    style: Constants.StyleFilterTextUnderline,
                  ),
                  onTap: () {
                    AtotoApi()
                        .movieGenres(section: widget.section)
                        .then((value) => {
                              reportList.clear(),
                              reportGenreList.clear(),
                              setState(() {
                                value.genres.forEach((element) {
                                  reportList.add(element.text);
                                  reportGenreList.add(element);
                                });
                              }),
                              _showReportDialog(
                                  Constants.genreTitleFilterText, movieBloc)
                            });
                  },
                ));
            }),
        InkWell(
            child:
            const Icon(Icons.clear, color: Constants.darkBlueColor),
            onTap: () {
              _clearGenre(movieBloc);
            }),
      ],
    );
  }
}
