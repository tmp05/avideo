import 'package:avideo/models/filters.dart';
import 'package:avideo/widgets/filters/adds.dart';
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
    //final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    MovieFilters currentFilter= MovieFilters();

    movieBloc.outFilters.listen((MovieFilters filters){
      currentFilter = Adds().copyFilter(filters);
    });

    return       Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: <Widget>[

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
