import 'package:html_unescape/html_unescape.dart';

class Studios {
  Studios(this.value, this.text, this.countTag);

  Studios.fromJSON(Map<String, dynamic> json)
      : value = json['value'],
        text  = HtmlUnescape().convert( json['text'].replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"')),
        countTag  = json['count_video']==null?0:json['count_video'];

  final String text;
  final int value;
  final int countTag;

}


class StudiosList {
  StudiosList.fromJSON(List<dynamic> json)
      : studios = json.map((dynamic i)=>Studios.fromJSON(i)).toList();

  List<Studios> studios = <Studios>[];

}