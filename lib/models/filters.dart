import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/genre.dart';

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
  int studio;
  SortItem sort;

}