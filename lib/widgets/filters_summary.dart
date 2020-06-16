import 'package:avideo/blocs/application_bloc.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/filters.dart';
import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';

import '../constants.dart';

class FiltersSummary extends StatelessWidget {
  const FiltersSummary({
    Key key,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieCatalogBloc movieBloc = BlocProvider.of<MovieCatalogBloc>(context);
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    MovieFilters currentFilter= MovieFilters();

    movieBloc.outFilters.listen((MovieFilters filters){
      currentFilter =  MovieFilters(
          minReleaseDate: filters.minReleaseDate,
          maxReleaseDate: filters.maxReleaseDate,
          sort: filters.sort,
          genre: filters.genre);
    });

    return       Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: <Widget>[
          StreamBuilder<List<Genre>>(
            stream: appBloc.outMovieGenres,
            builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot){
              if (snapshot.data==null)
                return Container();
              else
                return  DropdownButton<Genre>(
                  hint: const Text(Constants.genreFilterText),
                  items: snapshot.data.map((Genre genre) {
                    return DropdownMenuItem<Genre>(
                      value: genre,
                      child: Text(genre.title),
                    );
                  }).toList(),
                  onChanged: (Genre newMovieGenre) {
                    if (currentFilter.genre!=newMovieGenre) {
                      currentFilter.genre = newMovieGenre;
                      movieBloc.inFilters.add(currentFilter);
                    }
                  });
            },
          ),
          StreamBuilder<List<int>>(
            stream: movieBloc.outReleaseDates,
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
              if (snapshot.hasData){
                return Text('Years: [${snapshot.data[0]} - ${snapshot.data[1]}]');
              }
              return Container();
            },
          ),
          DropdownButton<SortItem>(
            onChanged: (SortItem value) {
             if (currentFilter.sort!=value) {
                  currentFilter.sort = value;
                  movieBloc.inFilters.add(currentFilter);
                }
            },
            hint: const Text(Constants.sortText),
            items: Constants.sortItems.map((SortItem item) {
              return  DropdownMenuItem<SortItem>(
                value: item,
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 5,),
                    Text(item.name,style:  const TextStyle(color: Constants.blackColor)),
                  ],
                ),
              );
            }).toList(),
          )
//          StreamBuilder<int>(
//            stream: movieBloc.outTotalMovies,
//            builder: (BuildContext context, AsyncSnapshot<int> snapshot){
//              return Text('Total: ${snapshot.data}');
//            },
//          ),
        ]);
  }



}
