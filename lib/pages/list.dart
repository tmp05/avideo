import 'dart:async';

import 'package:avideo/models/filters.dart';
import 'package:avideo/widgets/filters/adds.dart';
import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/favorite_bloc.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:avideo/pages/filters.dart';
import 'package:avideo/widgets/main_menu_widget.dart';
import 'package:avideo/widgets/movie_card_widget.dart';
import 'package:avideo/pages/video_card.dart';

import '../constants.dart';

class ListPage extends StatelessWidget {
  ListPage({
    Key key,
    this.section,
  }) : super(key: key);

  final String section;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc =
        BlocProvider.of<MovieCatalogBloc>(context);
    movieBloc.changeSection(section);
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    //setting new empty filters
    movieBloc.inFilters.add(MovieFilters());
    MovieFilters _currentFilter;
    final TextEditingController _searchQuery = new TextEditingController();

    void _openEndDrawer() {
      _scaffoldKey.currentState.openEndDrawer();
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const MainMenuWidget(),
            Align(
                alignment: Alignment.topRight,
                child: StreamBuilder<MovieFilters>(
                    stream: movieBloc.outFilters,
                    builder: (BuildContext context,
                        AsyncSnapshot<MovieFilters> snapshot) {
                      if (snapshot.data != null)
                        _currentFilter = Adds().copyFilter(snapshot.data);
                      return Row(
                          children: <Widget>[
                          Container(
                          width: 200,
                          child: TextField(
                          onChanged: (value) {
                            _currentFilter.query = value;
                            movieBloc.inFilters.add(_currentFilter);
                          },
                          controller: _searchQuery,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Constants.searchText,
                            prefixIcon: Icon(Icons.search),
                          ),
                        )),
                        InkWell(
                            child: Text(
                                _dataHasFiltres(snapshot.data)
                                    ? 'Установлены фильтры'
                                    : 'Фильтры',
                                style: _dataHasFiltres(snapshot.data)
                                    ? Constants.StyleAlertFilterTextUnderline
                                    : Constants.StyleNoFilterTextUnderline),
                            onTap: () => _openEndDrawer())
                      ]);
                    })),
            Expanded(
              // Display an infinite GridView with the list of all movies in the catalog,
              // that meet the filters
              child: StreamBuilder<List<SerialCard>>(
                  stream: movieBloc.outMoviesList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SerialCard>> snapshot) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width / 200).round(),
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildMovieCard(context, movieBloc, index,
                            snapshot.data, favoriteBloc.outFavorites);
                      },
                      itemCount:
                          (snapshot.data == null ? 0 : snapshot.data.length) +
                              30,
                    );
                  }),
            ),
          ],
        ),
        endDrawer: FiltersPage(
          section: section,
          movieBloc: movieBloc,
        ));
  }

  bool _dataHasFiltres(MovieFilters filter) {
    bool hasFilters = false;
    if (filter != null) {
      if (filter.genre != null && filter.genre.length > 0) hasFilters = true;
      if (filter.studio != null && filter.studio.length > 0) hasFilters = true;
      if (filter.maxReleaseDate != null &&
          filter.minReleaseDate != null &&
          (filter.maxReleaseDate < DateTime.now().year ||
              filter.minReleaseDate > 1910)) hasFilters = true;
    }
    return hasFilters;
  }

  Widget _buildMovieCard(
      BuildContext context,
      MovieCatalogBloc movieBloc,
      int index,
      List<SerialCard> movieCards,
      Stream<List<SerialCard>> favoritesStream) {
    // Notify the MovieCatalogBloc that we are rendering the MovieCard[index]
    movieBloc.inMovieIndex.add(index);

    // Get the MovieCard data
    final SerialCard movieCard =
        (movieCards != null && movieCards.length > index)
            ? movieCards[index]
            : null;

    if (movieCard == null) {
      return Container();
    }

    return MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        serialCard: movieCard,
        favoritesStream: favoritesStream,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return BlocProvider<MovieInfoBloc>(
                bloc: MovieInfoBloc(AtotoApi()),
                child: VideoCard(serial: movieCard));
          }));
        });
  }
}
