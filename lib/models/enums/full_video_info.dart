import 'package:avideo/models/channel_info.dart';
import 'package:avideo/models/enums/video_info.dart';
import 'package:avideo/models/enums/video_list.dart';

class FullVideoInfo extends Object {
  FullVideoInfo(this.videoInfo, this.videoList, this.channelInfo);
  FullVideoInfo.fromJSON(Map<String, dynamic> json)
      : videoInfo = VideoInfo.fromJSON( json['video']),
        videoList = VideoList.fromJSON( json['list']),
        channelInfo = ChannelInfo.fromJSON( json['channel']);

  final VideoInfo videoInfo;
  final VideoList videoList;
  final ChannelInfo channelInfo;
}
