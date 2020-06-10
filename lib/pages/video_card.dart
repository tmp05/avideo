import 'package:avideo/models/movie_info.dart';
import 'package:avideo/pages/video_player.dart';
import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';

import 'package:avideo/models/serial_card.dart';
import 'package:avideo/widgets/info_video_widget.dart';
import 'package:avideo/widgets/main_menu_widget.dart';
import 'package:avideo/widgets/season_list_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';
import 'package:avideo/widgets/video_list_widget.dart';

class VideoCard extends StatelessWidget {

  const VideoCard({
    Key key,
    this.serial,
  }) : super(key: key);

  final SerialCard serial;



  @override
  Widget build(BuildContext context) {
    final MovieInfoBloc movieBloc = BlocProvider.of<MovieInfoBloc>(context);
    movieBloc.requestMovie(serial.address);

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const MainMenuWidget(),
            TextRowWidget(showText:serial.title),
            Expanded(
                child: StreamBuilder<MovieInfo>(
                  stream: movieBloc.video,
                  builder: (BuildContext context, AsyncSnapshot<MovieInfo> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data.videoInfo!=null)  movieBloc.requestFullVideoInfo(snapshot.data.videoInfo.id);
                      return CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                                child: InfoVideoWidget(data: snapshot.data, style: Theme.of(context).textTheme.bodyText1, serial: serial)),
                            SliverToBoxAdapter(
                                child: SeasonListWidget(data: snapshot.data,)),
                            SliverToBoxAdapter(
                                child: snapshot.data.videoInfo==null?Container():VideoPlayer()),
                            SliverToBoxAdapter(
                                child:VideoListWidget(initialVideos: snapshot.data.videos))
                          ]);
                    }
                  },
                )),
          ]
      ),
    );
  }

}