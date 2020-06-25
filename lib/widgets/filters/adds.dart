import 'package:avideo/models/filters.dart';


class Adds {
  MovieFilters copyFilter(MovieFilters filter){
    return MovieFilters(
      minReleaseDate: filter.minReleaseDate,
      maxReleaseDate: filter.maxReleaseDate,
      genre: filter.genre,
      country: filter.country,
      studio: filter.studio,
      sort: filter.sort,
      query: filter.query
    );
  }
}