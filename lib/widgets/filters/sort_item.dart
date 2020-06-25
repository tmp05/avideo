import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'adds.dart';

class SortItemWidget extends StatelessWidget {
  const SortItemWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context);

    MovieFilters _currentFilter = MovieFilters();
    return StreamBuilder<MovieFilters>(
        stream: movieBloc.outFilters,
        builder: (BuildContext context, AsyncSnapshot<MovieFilters> snapshot) {
          if (snapshot.data != null)
            _currentFilter = Adds().copyFilter(snapshot.data);
          return DropdownButton<SortItem>(
            onChanged: (SortItem value) {
              if (_currentFilter.sort != value) {
                _currentFilter.sort = value;
                movieBloc.inFilters.add(_currentFilter);
              }
            },
            value: _currentFilter != null ? _currentFilter.sort : null,
            hint: const Text(
              Constants.sortText,
              style: Constants.StyleFilterTextUnderline,
            ),
            items: Constants.sortItems.map((SortItem item) {
              return DropdownMenuItem<SortItem>(
                value: item,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 5,
                    ),
                    Text(item.name, style: Constants.StyleFilterTextUnderline),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
