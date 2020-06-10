import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/models/enums/full_video_info.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:avideo/blocs/movie_info_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key key,
  }) : super(key: key);


  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayer> {
  ChewieController _chewieController;
  VideoPlayerController _controller;
  MovieInfoBloc movieBloc;
  Future<void> _future;

  @override
  void initState() {
    movieBloc = BlocProvider.of<MovieInfoBloc>(context);
    super.initState();
  }


  buildPlaceholderImage(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> initVideoPlayer(String url) async{
    print(url);
      _controller = VideoPlayerController.network(url);
      try {
      await _controller.initialize().then((value) =>
        _chewieController = ChewieController(
            videoPlayerController: _controller,
            aspectRatio: _controller.value.aspectRatio,
            autoPlay: true,
            looping: true,
            placeholder: buildPlaceholderImage()
        )
      ).catchError((onError)=>throw Exception('Failed to catch video'));}
      on Exception catch (exception) {
         throw Exception(exception.toString());
       } catch (error) {
         throw Exception(error.toString());
    }

      return _chewieController;
  }

  @override
  Widget build(BuildContext context){
    return  StreamBuilder<FullVideoInfo>(
      stream: movieBloc.fullVideoInfo,
      builder: (BuildContext context, AsyncSnapshot<FullVideoInfo> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        else {
          _future = initVideoPlayer(snapshot.data.videoInfo.url1);
          return    Container(
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshotF){
                  if(snapshotF.connectionState != ConnectionState.done) return buildPlaceholderImage();
                  else if (snapshotF.error!=null) return Center (child: Text(snapshotF.error.toString()));
                  else  return Center(
                    child: Chewie(controller: snapshotF.data,),
                  );
                },
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
  }
}
