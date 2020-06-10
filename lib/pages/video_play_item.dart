import 'package:avideo/models/enums/full_video_info.dart';
import 'package:avideo/models/movie_info.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:avideo/models/enums/video.dart';
import 'package:avideo/models/enums/video_info.dart';
import 'package:avideo/models/enums/video_list.dart';
import 'package:avideo/widgets/main_menu_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';
import 'package:avideo/widgets/video_list_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayItem extends StatefulWidget {
  const VideoPlayItem({
    this.looping,
    @required this.video,
    this.videoInfo,
    @required this.videoList,
    this.play,
    this.selectedVideo,
    Key key,
  }) : super(key: key);

  final bool looping;
  final Video video;
  final MovieInfo videoInfo;
  final VideoList videoList;
  final bool play;
  final int selectedVideo;


  @override
  _VideoPlayItemState createState() => _VideoPlayItemState();
}

class _VideoPlayItemState extends State<VideoPlayItem> {
  ChewieController _chewieController;
  VideoPlayerController _controller;
  MovieInfoBloc _bloc;
  VideoInfo _currentVideo;

  @override
  void initState() {
    _bloc = MovieInfoBloc(AtotoApi());
    _bloc.requestFullVideoInfo(widget.video.id);
    super.initState();
  }


  void _setVideoController(VideoInfo data) {

    if (_controller!=null)
      _controller.dispose();
    if (_chewieController!=null)
      _chewieController.dispose();

    _controller = VideoPlayerController.network(data.url1);

    print(data.url1);
    print(data.url2);

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: true,
      looping: widget.looping,
      errorBuilder: (BuildContext context, String errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style:  const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    _controller.addListener(checkIfVideoFinished);
  }

  void checkIfVideoFinished() {
    if (_controller == null ||
        _controller.value == null ||
        _controller.value.position == null ||
        _controller.value.duration == null)
          return;

    if (_controller.value.position.inSeconds ==
        _controller.value.duration.inSeconds) {
        //Здесь запускаем новое видео
        api.getVideoNext(_currentVideo.id, _currentVideo.channel,'0').then((int onValue){
          if (onValue!=null) {
            _bloc.requestFullVideoInfo(onValue);
            _bloc.changeSelectedVideo(onValue);
          }
        });
        _controller.removeListener(checkIfVideoFinished);
    }
  }



   @override
  Widget build(BuildContext context){
     return  StreamBuilder<FullVideoInfo>(
         stream: _bloc.fullVideoInfo,
         builder: (BuildContext context, AsyncSnapshot<FullVideoInfo> snapshot) {
         if (!snapshot.hasData)
           return const Center(child: CircularProgressIndicator());
         else {
           _setVideoController(snapshot.data.videoInfo);
           _bloc.requestSeasonVideoList(snapshot.data.videoList);
           _currentVideo = snapshot.data.videoInfo;
            return   Scaffold(
               body:  CustomScrollView(
                           slivers: <Widget>[
                             const SliverToBoxAdapter(child: MainMenuWidget()),
                             SliverToBoxAdapter(child: TextRowWidget(showText:snapshot.data.videoInfo.shTitle)),
                             SliverToBoxAdapter(
                                 child: Chewie(controller: _chewieController)),
                             SliverToBoxAdapter(
                                 child:VideoListWidget(initialVideos: snapshot.data.videoList,bloc:_bloc, selectedVideo: _currentVideo.id))
                           ]
                 )
               );
            }
         }, );
  }


  @override
  void dispose() {
   super.dispose();
   if (_controller!=null)
      _controller.dispose();
   if (_chewieController!=null)
     _chewieController.dispose();
   _bloc.dispose();
  }
}
