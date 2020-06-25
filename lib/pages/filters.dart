import 'package:avideo/widgets/filters/country_filter.dart';
import 'package:avideo/widgets/filters/genre_filtre.dart';
import 'package:avideo/widgets/filters/sort_item.dart';
import 'package:avideo/widgets/filters/studio_filter.dart';
import 'package:avideo/widgets/filters/years_filter.dart';
import 'package:flutter/material.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';

class FiltersPage extends StatelessWidget {
  const FiltersPage({Key key, this.section, this.movieBloc}) : super(key: key);

  final String section;
  final MovieCatalogBloc movieBloc;

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
            StudioFilter(
              section: section,
              movieBloc: movieBloc,
            ),
            Container(
              height: 10,
            ),
            GenreFilter(
              section: section,
              movieBloc: movieBloc,
            ),
            Container(
              height: 10,
            ),
            CountryFilter(
              section: section,
              movieBloc: movieBloc,
            ),
            Container(
              height: 10,
            ),
            YearFilter(
              section: section,
              movieBloc: movieBloc,
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
}
