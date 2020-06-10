import 'dart:async';
import 'dart:collection';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/models/enums/genre.dart';
import 'package:avideo/models/enums/genres_list.dart';

class ApplicationBloc implements BlocBase {

  ApplicationBloc() {
   api.movieGenres().then((GenresList list) {
      _genresList = list;
    });

    _cmdController.stream.listen((_){
      _syncController.sink.add(UnmodifiableListView<Genre>(_genresList.genres));
    });
  }

  final StreamController<List<Genre>> _syncController = StreamController<List<Genre>>.broadcast();
  Stream<List<Genre>> get outMovieGenres => _syncController.stream;

  /// 
  final StreamController<List<Genre>> _cmdController = StreamController<List<Genre>>.broadcast();
  StreamSink <List<Genre>> get getMovieGenres => _cmdController.sink;



  @override
  void dispose(){
    _syncController.close();
    _cmdController.close();

  }

  GenresList _genresList;
 
}
