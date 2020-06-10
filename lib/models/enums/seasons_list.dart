import 'package:avideo/models/enums/seasons.dart';

class SeasonsList {
  SeasonsList.fromJSON(List<dynamic> json)
      : seasons = json.map((dynamic i)=>Season.fromJSON(i)).toList();

  List<Season> seasons = <Season>[];

  Season findById(int season) => seasons.firstWhere((g) => g.id == season);

  int count() => seasons.length;
}
