import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/widgets/filters/studio_filter.dart';
import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';

class DrawerFiltersWidget extends StatelessWidget {
  const DrawerFiltersWidget({Key key, this.section}) : super(key: key);

  final String section;

  @override
  Widget build(BuildContext context) {
    MovieCatalogBloc _movieBloc = BlocProvider.of<MovieCatalogBloc>(context);
    return Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          StudioFilter(
            section: section,
            movieBloc: _movieBloc,
          )
        ]));
  }
}
