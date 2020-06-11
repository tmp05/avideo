import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/video.dart';
import 'package:avideo/models/enums/video_list.dart';
import 'package:avideo/pages/video_play_item.dart';
import 'package:avideo/widgets/image_widget.dart';



class VideoListWidget extends StatelessWidget {
  const VideoListWidget( {
    Key key,
    this.initialVideos,
    this.bloc,
    this.selectedVideo,
  }) : super(key: key);

  final VideoList initialVideos;
  final MovieInfoBloc bloc;
  final int selectedVideo;


  String _getText(String text){
    return text.substring(text.lastIndexOf(',')+1);
  }

  @override
  Widget build(BuildContext context) {
    MovieInfoBloc movieBloc;
    BoxDecoration _decoration;

    if (bloc!=null)
       movieBloc = bloc;
    else
      movieBloc = BlocProvider.of<MovieInfoBloc>(context);

    final double size = MediaQuery.of(context).size.width/(MediaQuery.of(context).size.width/160.round());

    return Container(
        height: size,
        child: StreamBuilder<VideoList>(
        stream: movieBloc.videoList,
        initialData: initialVideos,
        builder: (BuildContext context, AsyncSnapshot<VideoList> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return StreamBuilder<int>(
              stream: movieBloc.curVideo,
              builder: (BuildContext context, AsyncSnapshot<int> snapshotVideo) {
                return  ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.videos.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final Video video = snapshot.data.videos[index];
                    if (video.id == selectedVideo)
                      _decoration = BoxDecoration( border: Border.all(color: Constants.darkBlueColor,width: 3,));
                    else
                      _decoration = null;
                    return Column (
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            width:size,
                            decoration: _decoration,
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              child: ImageWidget(section: video.section,photo: video.key,preview: video.preview,size: 160),
                              onTap: () {
                                movieBloc.changeSelectedVideo(video.id);
                                if (bloc!=null){
                                  bloc.requestFullVideoInfo(video.id);
                                }
                                else {
                                  Navigator
                                      .of(context)
                                      .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                                    return BlocProvider<MovieInfoBloc>(
                                        bloc: MovieInfoBloc(AtotoApi()),
                                        child: VideoPlayItem(video: video, videoList: snapshot.data, selectedVideo:video.id)
                                    );
                                  }));}
                              },
                            )
                        ),
                        Container(
                            width:size+20,
                            child: Padding( // some padding
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(_getText(video.title),style: Theme.of(context).textTheme.bodyText1,overflow: TextOverflow.fade, maxLines: 3,),
                            )
                        ),
                      ],
                    );
                  },
                );
              }
          );
       }
      },
    ));
  }
}
