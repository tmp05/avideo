import 'package:avideo/models/enums/video.dart';

class VideoList {
  VideoList.fromJSON(List<dynamic> json)
      : videos = json.map((dynamic i) => Video.fromJSON(i)).toList();

  List<Video> videos = <Video>[];

  Video findById(int video) => videos.firstWhere((g) => g.id == video);

  int count() => videos.length;
}
