import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/country.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/enums/studios.dart';

class MovieFilters {
  MovieFilters({
    this.minReleaseDate,
    this.maxReleaseDate,
    this.genre,
    this.country,
    this.studio,
    this.sort,
    this.query
  });

  int minReleaseDate;
  int maxReleaseDate;
  List<Genre> genre;
  List<Country> country;
  List<Studios>  studio;
  SortItem sort;
  String query;

}