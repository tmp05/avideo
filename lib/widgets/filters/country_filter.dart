import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/enums/country.dart';
import 'package:avideo/models/filters.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../multi_select_chip_widget.dart';

import 'package:avideo/widgets/filters/adds.dart';

class CountryFilter extends StatefulWidget {
  const CountryFilter({Key key, this.section, this.movieBloc}) : super(key: key);

  final String section;
  final MovieCatalogBloc movieBloc;

  @override
  CountryFilterState createState() {
    return CountryFilterState();
  }
}

class CountryFilterState extends State<CountryFilter> {
  List<String> reportList = List();
  List<String> selectedReportList = List();

  List<Country> reportCountryList = List();
  List<Country> selectedCountryReportList = List();

  MovieFilters _currentFilter;

  _clearCountry() {
    setState(() {
      _currentFilter.country = List<Country>();
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  _clearItem(Country country) {
    setState(() {
      _currentFilter.country.remove(country);
      selectedReportList.remove(country.text);
      widget.movieBloc.inFilters.add(_currentFilter);
    });
  }

  _setCountry() {
    setState(() {
      if (selectedReportList.isNotEmpty) {
        selectedCountryReportList.clear();
        selectedReportList.forEach((element) {
          selectedCountryReportList
              .add(reportCountryList.firstWhere((Country c) => c.text == element));
        });
        _currentFilter.country = selectedCountryReportList;
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
                  _setCountry();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String convertCountriesToString(List<Country> data) {
    List<String> stringList = List();
    data.forEach((element) {
      stringList.add(element.text);
    });
    return stringList.join(" , ");
  }

  onPressed() {
    AtotoApi().movieCountries(widget.section).then((value) => {
      reportList.clear(),
      reportCountryList.clear(),
      setState(() {
        value.countries.forEach((element) {
          reportList.add(element.text);
          reportCountryList.add(element);
        });
      }),
      _showReportDialog(Constants.countryFilterText)
    });
  }

  _buildCountryList(List<Country> countryList) {
    List<Widget> _countryChoices = List();
    _countryChoices.add(textCountry());
    countryList.forEach((item) {
      _countryChoices.add(Container(
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
    return _countryChoices;
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
                _currentFilter = Adds().copyFilter(snapshot.data);
              if (snapshot.data == null ||
                  snapshot.data.country == null ||
                  snapshot.data.country.length == 0)
                return textCountry();
              else
                return SingleChildScrollView(
                    child: Wrap(
                      children: _buildCountryList(snapshot.data.country),
                    ));
            }),
      ],
    );
  }

  Widget textCountry() {
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
                  Constants.countryFilterText,
                  style: Constants.StyleFilterText,
                ),
                onPressed: () => onPressed(),
              )),
          InkWell(
              child: const Icon(Icons.clear, color: Constants.darkBlueColor),
              onTap: () {
                _clearCountry();
              }),
        ]));
  }
}