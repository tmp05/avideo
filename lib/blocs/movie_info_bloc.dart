
import 'dart:async';

import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/models/enums/full_video_info.dart';

import 'package:avideo/models/enums/video_list.dart';
import 'package:avideo/models/movie_info.dart';
import 'package:rxdart/rxdart.dart';

class MovieInfoBloc extends BlocBase {
  MovieInfoBloc(this.api) {
    _videoList = _seasonController.distinct().asyncMap(api.makeRequestVideoList).asBroadcastStream();
    _movie = _queryController.distinct().asyncMap(api.makeRequestMovie).asBroadcastStream();
    _fullVideoInfo = _videoController.distinct().asyncMap(api.makeRequestFullVideoInfo).asBroadcastStream();
  }

  final AtotoApi api;

  /// info about Movie. sink - address for api, stream - MovieInfo. RequestMovie adds a sink
  Stream<MovieInfo> _movie = const Stream<MovieInfo>.empty();
  Stream<MovieInfo> get video => _movie;

  final BehaviorSubject<String> _queryController = BehaviorSubject<String>();
  Sink<String> get query => _queryController;

  void requestMovie(String address){
    _queryController.add(address);
  }

  /// info about Videos in the season. sink - id of season, stream - VideoList. RequestSeasonVideoList adds a sink, and we have a listener for season id changing
  Stream<VideoList> _videoList = const Stream<VideoList>.empty();
  Stream<VideoList> get videoList => _videoList;

  final BehaviorSubject<dynamic> _seasonController = BehaviorSubject<dynamic>();
  Sink<dynamic> get seasonId => _seasonController.sink;

  void requestSeasonVideoList(dynamic data){
    _seasonController.add(data);
  }

  /// info about Video -  sink - id of video, stream - VideoInfo. RequestVideoInfo adds a sink
  Stream<FullVideoInfo> _fullVideoInfo = const Stream<FullVideoInfo>.empty();
  Stream<FullVideoInfo> get fullVideoInfo => _fullVideoInfo;

  final BehaviorSubject<int> _videoController = BehaviorSubject<int>();
  Sink<int> get videoId => _videoController;

  void requestFullVideoInfo(int id){
    _videoController.add(id);
  }

  // info about current season to change the color of item in the SeasonListWidget
  final BehaviorSubject<int> _seasonStream = BehaviorSubject<int>();
  Stream<int> get curSeason => _seasonStream.stream;
  Sink<int> get _changeSeason => _seasonStream.sink;

  void changeSelectedSeason(int data) {
    _changeSeason.add(data);
  }

  // info about current video to make a border
  final BehaviorSubject<int> _videoStream = BehaviorSubject<int>();
  Stream<int> get curVideo => _videoStream.stream;
  Sink<int> get _changeVideo => _videoStream.sink;


  void changeSelectedVideo(int data) {
    _changeVideo.add(data);
  }


    @override
  void dispose() {
    _queryController.close();
    _seasonController.close();
    _videoController.close();
    _seasonStream.close();
    _videoStream.close();
  }


}