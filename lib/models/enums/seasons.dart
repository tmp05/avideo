import 'package:html_unescape/html_unescape.dart';

class Season {
  Season(this.id, this.title, this.countVideo);

  Season.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title  = HtmlUnescape().convert( json['title'].replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"')),
        countVideo  = json['count_video'];

  final String title;
  final int id;
  final int countVideo;


}

