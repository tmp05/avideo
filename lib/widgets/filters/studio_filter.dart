import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/enums/studios.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';
import 'adds.dart';

class StudioFilter extends StatefulWidget {
  const StudioFilter({Key key, this.section, this.movieBloc}) : super(key: key);

  final String section;
  final MovieCatalogBloc movieBloc;

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

  _setStudio() {
    setState(() {
      if (selectedReportList.isNotEmpty) {
        selectedStudiosReportList.clear();
        selectedReportList.forEach((element) {
          selectedStudiosReportList.add(
              reportStudiosList.firstWhere((Studios g) => g.text == element));
        });
        _currentFilter.studio = selectedStudiosReportList;
        widget.movieBloc.inFilters.add(_currentFilter);
      }
    });
  }

  _clearStudio() {
    setState(() {
      _currentFilter.studio = List<Studios>();
      selectedReportList = List();
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  _clearItem(Studios studio) {
    setState(() {
      _currentFilter.studio.remove(studio);
      selectedReportList.remove(studio.text);
      widget.movieBloc.inFilters.add(_currentFilter);
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
                  _setStudio();
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

  onPressed() {
    AtotoApi().movieStudios(widget.section).then((value) => {
          reportList.clear(),
          reportStudiosList.clear(),
          setState(() {
            value.studios.forEach((element) {
              reportList.add(element.text);
              reportStudiosList.add(element);
            });
          }),
          _showReportDialog(Constants.studioTitleFilterText)
        });
  }

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context);

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        StreamBuilder<MovieFilters>(
            stream: movieBloc.outFilters,
            builder:
                (BuildContext context, AsyncSnapshot<MovieFilters> snapshot) {
              if (snapshot.data != null)
                _currentFilter = Adds().copyFilter(snapshot.data);
              if (snapshot.data == null ||
                  snapshot.data.studio == null ||
                  snapshot.data.studio.length == 0)
                return textStudio();
              else
                return SingleChildScrollView(
                    child: Wrap(
                  children: _buildStudioList(snapshot.data.studio),
                ));
            }),
      ],
    );
  }

  Widget textStudio() {
    return Container(
        width: 150,
        child:     Row(
          children: <Widget>[
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
                Constants.studioFilterText,
                style: Constants.StyleFilterText,
              ),
              onPressed: () => onPressed(),
            )),
            InkWell(
                child: const Icon(Icons.clear, color: Constants.darkBlueColor),
                onTap: () {
                  _clearStudio();
                }),
          ]));
  }

  _buildStudioList(List<Studios> studioList) {
    List<Widget> _studioChoices = List();
    _studioChoices.add(textStudio());
    studioList.forEach((item) {
      _studioChoices.add(Container(
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
    return _studioChoices;
  }
}
