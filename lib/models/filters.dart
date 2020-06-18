import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/enums/studios.dart';

class MovieFilters {
  MovieFilters({
    this.minReleaseDate,
    this.maxReleaseDate,
    this.genre,
    this.year,
    this.country,
    this.studio,
    this.sort
  });

  int minReleaseDate;
  int maxReleaseDate;
  List<Genre> genre;
  int year;
  int country;
  List<Studios>  studio;
  SortItem sort;

}