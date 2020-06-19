import 'dart:async';

import 'package:avideo/models/filters.dart';
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

    void _openEndDrawer() {
      _scaffoldKey.currentState.openEndDrawer();
    }

    String _getStringFromList(List<dynamic> list){
      List<String> stringList = List();
      list.forEach((element) {
        stringList.add(element.text);
      });
      return stringList.join(" , ");
   }

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const MainMenuWidget(),
          //      const FiltersSummary(),
          StreamBuilder<MovieFilters>(
              stream: movieBloc.outFilters,
              builder:
                  (BuildContext context, AsyncSnapshot<MovieFilters> snapshot) {


                String filterText = 'Отборы'+"\n";
                if (snapshot.data != null) {
                  if (snapshot.data.studio != null)
                    filterText =
                        filterText = filterText +'Киностудия: '+_getStringFromList(snapshot.data.studio)+ "\n";
                  if (snapshot.data.genre != null)
                    filterText = filterText +'Жанр: '+_getStringFromList(snapshot.data.genre)+ "\n";
                  if (snapshot.data.minReleaseDate!= null&&snapshot.data.maxReleaseDate!= null)
                    filterText =
                        filterText = filterText +'Год: '+snapshot.data.minReleaseDate.toString()+"-"+snapshot.data.maxReleaseDate.toString()+ "\n";
                  if (snapshot.data.sort!=null)
                    filterText =
                        filterText = filterText +'Сортировка: '+snapshot.data.sort.name;
                }
                return InkWell(
                    child: Text(filterText,style: Constants.StyleFilterTextUnderline), onTap: () => _openEndDrawer());
              }),
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
                    itemCount: (snapshot.data == null ? 0 : snapshot.data.length) + 30,
                  );
                }),
          ),
        ],
      ),
      endDrawer: FiltersPage(section: section),
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
