import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/favorite_bloc.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:avideo/pages/filters.dart';
import 'package:avideo/widgets/filters_summary.dart';
import 'package:avideo/widgets/main_menu_widget.dart';
import 'package:avideo/widgets/movie_card_widget.dart';
import 'package:avideo/pages/video_card.dart';

class ListPage extends StatelessWidget {
  ListPage( {
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
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const MainMenuWidget(),
          const FiltersSummary(),
          Expanded(
            // Display an infinite GridView with the list of all movies in the catalog,
            // that meet the filters
            child: StreamBuilder<List<SerialCard>>(
                stream: movieBloc.outMoviesList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<SerialCard>> snapshot) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                       return _buildMovieCard(context, movieBloc, index,
                          snapshot.data, favoriteBloc.outFavorites);
                    },
                    itemCount:
                        (snapshot.data == null ? 0 : snapshot.data.length) + 30,
                  );
                }),
          ),
        ],
      ),
      endDrawer: const FiltersPage(),
    );
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }


    return MovieCardWidget(
        key: Key('movie_${movieCard.id}'),
        serialCard: movieCard,
        favoritesStream: favoritesStream,
        onPressed: () {
          Navigator
              .of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return BlocProvider<MovieInfoBloc>(
              bloc: MovieInfoBloc(AtotoApi()),
              child: VideoCard(serial: movieCard)
            );
          }));
        });


  }
}
