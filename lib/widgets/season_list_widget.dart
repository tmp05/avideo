import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:avideo/models/movie_info.dart';

import '../constants.dart';


class SeasonListWidget extends StatelessWidget {
  const SeasonListWidget( {
    Key key,
    this.data,
  }) : super(key: key);

  final MovieInfo data;

  @override
  Widget build(BuildContext context) {
    final MovieInfoBloc movieInfoBloc =  BlocProvider.of<MovieInfoBloc>(context);

    return StreamBuilder<int>(
        stream: movieInfoBloc.curSeason,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return  Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.seasons.count(),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // width: MediaQuery.of(context).size.width * 0.3,
                    width:data.seasons.seasons[index].title.length<10?110: data.seasons.seasons[index].title.length.toDouble()*7+50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:   snapshot.data ==data.seasons.seasons[index].id?
                                    Constants.darkBlueColor
                                    :snapshot.data==0&&index==0?Constants.darkBlueColor:Constants.lightBlueColor,
                        border: Border.all(
                            color: Constants.lightBlueColor,
                            width: 2.0
                        )
                    ),
                    child: InkWell(
                      child: Text(data.seasons.seasons[index].title, style: Constants.StyleTextSeries,),
                      onTap: () {
                        movieInfoBloc.requestSeasonVideoList(data.seasons.seasons[index].id.toString());
                        movieInfoBloc.changeSelectedSeason(data.seasons.seasons[index].id);
                      },
                    )
                );
              },
            ),
          );
       });


  }
}
