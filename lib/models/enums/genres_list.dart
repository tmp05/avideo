import 'package:avideo/models/enums/genre.dart';

class GenresList {
  GenresList.fromJSON(List<dynamic> json)
      : genres = json.map((dynamic i)=>Genre.fromJSON(i)).toList();

  List<Genre> genres = <Genre>[];

  Genre findById(int genre) => genres.firstWhere((Genre g) => g.id == genre);
}
