import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';

class GenreFilter extends StatefulWidget {
  const GenreFilter({Key key, this.section, this.movieBloc}) : super(key: key);

  final String section;
  final MovieCatalogBloc movieBloc;

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

  _clearGenre() {
    setState(() {
      _currentFilter.genre = List<Genre>();
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  _clearItem(Genre genre) {
    setState(() {
      _currentFilter.genre.remove(genre);
      selectedReportList.remove(genre.text);
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  _setGenre() {
    setState(() {
      if (selectedReportList.isNotEmpty) {
        selectedGenreReportList.clear();
        selectedReportList.forEach((element) {
          selectedGenreReportList
              .add(reportGenreList.firstWhere((Genre g) => g.text == element));
        });
        _currentFilter.genre = selectedGenreReportList;
        widget.movieBloc.inFilters.add(_currentFilter);
      }
    });
  }

  _showReportDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text(text),
            content: MultiSelectChip(
              reportList,
              selectedReportList,
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
                  _setGenre();
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

  onPressed() {
    AtotoApi().movieGenres(section: widget.section).then((value) => {
          reportList.clear(),
          reportGenreList.clear(),
          setState(() {
            value.genres.forEach((element) {
              reportList.add(element.text);
              reportGenreList.add(element);
            });
          }),
          _showReportDialog(Constants.genreTitleFilterText)
        });
  }

  _buildGenreList(List<Genre> genreList) {
    List<Widget> _genreChoices = List();
    _genreChoices.add(textGenre());
    genreList.forEach((item) {
      _genreChoices.add(Container(
          padding: const EdgeInsets.all(1.0),
          child: ActionChip(
            labelPadding: EdgeInsets.all(2.0),
            avatar: CircleAvatar(
                backgroundColor: Constants.lightBlueColor,
                child: const Icon(Icons.clear)),
            label: Text(item.text.toString()),
            onPressed: () => _clearItem(item),
          )));
    });
    return _genreChoices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        StreamBuilder<MovieFilters>(
            stream: widget.movieBloc.outFilters,
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
              if (snapshot.data == null ||
                  snapshot.data.genre == null ||
                  snapshot.data.genre.length == 0)
                return textGenre();
              else
                return SingleChildScrollView(
                    child: Wrap(
                  children: _buildGenreList(snapshot.data.genre),
                ));
            }),
      ],
    );
  }

  Widget textGenre() {
    return Container(
        width: 100,
        child: Row(children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                color: Constants.lightBlueColor,
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                border: new Border.all(color: Color.fromRGBO(0, 0, 0, 0.0)),
              ),
              child: ActionChip(
                labelPadding: EdgeInsets.all(2.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                label: Text(
                  Constants.genreFilterText,
                  style: Constants.StyleFilterText,
                ),
                onPressed: () => onPressed(),
              )),
          InkWell(
              child: const Icon(Icons.clear, color: Constants.darkBlueColor),
              onTap: () {
                _clearGenre();
              }),
        ]));
  }
}
