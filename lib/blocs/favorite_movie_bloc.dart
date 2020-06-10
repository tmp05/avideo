import 'dart:async';

import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteMovieBloc implements BlocBase {

  FavoriteMovieBloc(SerialCard movieCard){
    _favoritesController.stream
        .map((List<SerialCard> list) => list.any((SerialCard item) => item.id == movieCard.id))
        .listen((bool isFavorite) => _isFavoriteController.add(isFavorite));
  }
  ///
  /// A stream only meant to return whether THIS movie is part of the favorites
  ///
  final BehaviorSubject<bool> _isFavoriteController = BehaviorSubject<bool>();
  Stream<bool> get outIsFavorite => _isFavoriteController.stream;
    ///
  /// Stream of all the favorites
  ///
  final StreamController<List<SerialCard>> _favoritesController = StreamController<List<SerialCard>>();
  Sink<List<SerialCard>> get inFavorites => _favoritesController.sink;



  @override
  void dispose(){
    _favoritesController.close();
    _isFavoriteController.close();
  }
}