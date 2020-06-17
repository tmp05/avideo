import 'dart:async';
import 'dart:collection';

import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:avideo/models/filters.dart';
import 'package:avideo/models/serial_page_result.dart';
import 'package:rxdart/rxdart.dart';

class MovieCatalogBloc implements BlocBase {
   String section;
   SortItem _sort;
  ///
  /// Constructor
  ///`
  MovieCatalogBloc() {
    outSection.listen((String curSection) => section = curSection);

    outSort.listen((SortItem curSort) => _sort = curSort);
    //
    // As said, each time we will have to render a MovieCard, the latter will send us
    // the [index] of the movie to render.  If the latter has not yet been fetched
    // we will need to fetch the page from the Internet.
    // Therefore, we need to listen to such request in order to handle the request.
    //
    _indexController.stream
    // take some time before jumping into the request (there might be several ones in a row)
        .bufferTime(const Duration(microseconds: 500))
    // and, do not update where this is no need
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);

    //
    // When filters are changed, we need to consider the changes
    //
    outFilters.listen(_handleFilters);

  }
  ///
  /// Max number of movies per fetched page
  ///
  final int _moviesPerPage = 20;

  ///
  /// Genre
  ///
   List<Genre> _genreList;

  ///
  /// Release date min
  /// 
  int _minReleaseDate = 2001;

  ///
  /// Release date max
  /// 
  int _maxReleaseDate = 2006;

    ///
  /// List of all the movie pages that have been fetched from Internet.
  /// We use a [Map] to store them, so that we can identify the pageIndex
  /// more easily.
  ///
  final Map<int, SerialPageResult> _fetchPages = <int, SerialPageResult>{};

  ///
  /// List of the pages, currently being fetched from Internet
  ///
  final Set<int> _pagesBeingFetched = <int>{};

  // ##########  STREAMS  ##############

  ///
  /// We are going to need the list of movies to be displayed
  ///
  final PublishSubject<List<SerialCard>> _moviesController = PublishSubject<List<SerialCard>>();
  Sink<List<SerialCard>> get _inMoviesList => _moviesController.sink;
  Stream<List<SerialCard>> get outMoviesList => _moviesController.stream;

 //info about current section
  final PublishSubject<String> _sectionController = PublishSubject<String>();
  Stream<String> get outSection => _sectionController.stream;

   void changeSection(String section){
     _sectionController.add(section);
   }

   //info about current genre
   final PublishSubject<List<Genre>> _genreController = PublishSubject<List<Genre>>();
   Stream<List<Genre>> get outGenre => _genreController.stream;


  //info about current sort
   final PublishSubject<SortItem> _sortController = PublishSubject<SortItem>();
   Stream<SortItem> get outSort => _sortController.stream;

  ///
  /// Each time we need to render a MovieCard, we will pass its [index]
  /// so that, we will be able to check whether it has already been fetched
  /// If not, we will automatically fetch the page
  ///
  final PublishSubject<int> _indexController = PublishSubject<int>();
  Sink<int> get inMovieIndex => _indexController.sink;

  ///
  /// Let's put to the limits of the automation...
  /// Let's consider listeners interested in knowing if a modification
  /// has been applied to the filters and total of movies, fetched so far
  ///
  final BehaviorSubject<int> _totalMoviesController = BehaviorSubject<int>(seedValue: 0);
  final BehaviorSubject<List<int>> _releaseDatesController = BehaviorSubject<List<int>>(seedValue: <int>[2000,2005]);
  Sink<List<int>> get _inReleaseDates => _releaseDatesController.sink;
  Stream<List<int>> get outReleaseDates => _releaseDatesController.stream;



  ///
  /// We also want to handle changes to the filters
  ///
  final BehaviorSubject<MovieFilters> _filtersController = BehaviorSubject<MovieFilters>();
  Sink<MovieFilters> get inFilters => _filtersController.sink;
  Stream<MovieFilters> get outFilters => _filtersController.stream;



  // info about current season
  final BehaviorSubject<SerialCard> _curSerialStream = BehaviorSubject<SerialCard>();
  Stream<SerialCard> get curSerial => _curSerialStream.stream;
  Sink<SerialCard> get _changeSerial => _curSerialStream.sink;


  void changeCurSerial(SerialCard data) {
    _changeSerial.add(data);
  }

  @override
  void dispose(){
    _moviesController.close();
    _indexController.close();
    _totalMoviesController.close();
    _releaseDatesController.close();
    _genreController.close();
    _filtersController.close();
    _curSerialStream.close();
    _sectionController.close();
    _sortController.close();
  }

  // ############# HANDLING  #####################

  ///
  /// For each of the movie index(es), we need to check if the latter
  /// has already been fetched.  As the user might scroll rapidly, this
  /// might end up with multiple pages (since a page contains max 20 movies)
  /// to be fetched from Internet.
  ///
  void _handleIndexes(List<int> indexes){
    // Iterate all the requested indexes and,
    // get the index of the page corresponding to the index

     for(final int index in indexes) {
   // for(var index in indexes){
      final int pageIndex = 1 + ((index+1) ~/ _moviesPerPage);

      // check if the page has already been fetched
      if (!_fetchPages.containsKey(pageIndex)){
        // the page has NOT yet been fetched, so we need to
        // fetch it from Internet
        // (except if we are already currently fetching it)
        if (!_pagesBeingFetched.contains(pageIndex)){
          // Remember that we are fetching it
          _pagesBeingFetched.add(pageIndex);
          // Fetch it
          api.pagedList(section:section,
                        pageIndex: pageIndex,
                        sort:_sort,
                        genreList: _genreList,
                        minYear: _minReleaseDate,
                        maxYear: _maxReleaseDate)
              .then((SerialPageResult fetchedPage) => _handleFetchedPage(fetchedPage, pageIndex));
        }
      }
    }
  }

  ///
  /// Once a page has been fetched from Internet, we need to
  /// 1) record it
  /// 2) notify everyone who might be interested in knowing it
  /// 
  void _handleFetchedPage(SerialPageResult page, int pageIndex){
    // Remember the page
    _fetchPages[pageIndex] = page;
    // Remove it from the ones being fetched
    _pagesBeingFetched.remove(pageIndex);
   
    // Notify anyone interested in getting access to the content
    // of all pages... however, we need to only return the pages
    // which respect the sequence (since MovieCard are in sequence)
    // therefore, we need to iterate through the pages that are
    // actually fetched and stop if there is a gap.
    final List<SerialCard> movies = <SerialCard>[];
    final List<int> pageIndexes = _fetchPages.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];

    // If the first page being fetched does not correspond to the first one, skip
    // and as soon as it will become available, it will be time to notify
    if (minPageIndex == 1){
      for (int i = 1; i <= maxPageIndex; i++){
        if (!_fetchPages.containsKey(i)){
          // As soon as there is a hole, stop
          break;
        }
        // Add the list of fetched movies to the list
        if (_fetchPages[i]!=null) {
            movies.addAll(_fetchPages[i].series);
        }
      }
    }

    // Take the opportunity to remember the number of movies
    // and notify who might be interested in knowing it
//    if (_totalMovies == -1){
//      _totalMovies = page.totalResults;
//      _inTotalMovies.add(_totalMovies);
//    }

    // Only notify when there are movies
    if (movies.isNotEmpty){
      _inMoviesList.add(UnmodifiableListView<SerialCard>(movies));
    }
  }

  ///
  /// We want to set new filters
  ///
  void _handleFilters(MovieFilters result){
    // First, let's record the new filter information
    _minReleaseDate = result.minReleaseDate;
    _maxReleaseDate = result.maxReleaseDate;
    _genreList = result.genre;
    _sort = result.sort;

    _fetchPages.clear();
    _pagesBeingFetched.clear();

    // Let's notify who needs to know
    _genreController.add(_genreList);
    //_inGenre.add(_genreList);
    _inReleaseDates.add(<int>[_minReleaseDate, _maxReleaseDate]);
    _sortController.add(_sort);


    // we need to tell about a change so that we pick another list of movies
    _inMoviesList.add(<SerialCard>[]);
  }
}
