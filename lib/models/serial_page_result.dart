import 'package:avideo/models/serial_card.dart';

class SerialPageResult {
  SerialPageResult.fromJSON(Map<String, dynamic> json)
      :hasMore = json['meta']['hasMore'],
        series = (json['data'] as List<dynamic>).map((dynamic json) => SerialCard.fromJSON(json)).toList();

  final bool hasMore;
  final List<SerialCard> series;


}