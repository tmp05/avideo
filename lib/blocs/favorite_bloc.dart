import 'dart:async';
import 'dart:collection';

import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:rxdart/rxdart.dart';


class FavoriteBloc implements BlocBase {

  FavoriteBloc(){
    _favoriteAddController.listen(_handleAddFavorite);
    _favoriteRemoveController.listen(_handleRemoveFavorite);
  }
  ///
  /// Unique list of all favorite movies
  ///
  final Set<SerialCard> _favorites = <SerialCard>{};

  // ##########  STREAMS  ##############
  ///
  /// Interface that allows to add a new favorite movie
  ///
  final BehaviorSubject<SerialCard> _favoriteAddController = BehaviorSubject<SerialCard>();
  Sink<SerialCard> get inAddFavorite => _favoriteAddController.sink;

  ///
  /// Interface that allows to remove a movie from the list of favorites
  ///
  final BehaviorSubject<SerialCard> _favoriteRemoveController = BehaviorSubject<SerialCard>();
  Sink<SerialCard> get inRemoveFavorite => _favoriteRemoveController.sink;

  ///
  /// Interface that allows to get the total number of favorites
  ///
  final BehaviorSubject<int> _favoriteTotalController =  BehaviorSubject<int>(seedValue: 0);
  Sink<int> get _inTotalFavorites => _favoriteTotalController.sink;
  Stream<int> get outTotalFavorites => _favoriteTotalController.stream;

  ///
  /// Interface that allows to get the list of all favorite movies
  ///
  final BehaviorSubject<List<SerialCard>> _favoritesController = BehaviorSubject<List<SerialCard>>(seedValue: []);
  Sink<List<SerialCard>> get _inFavorites =>_favoritesController.sink;
  Stream<List<SerialCard>> get outFavorites =>_favoritesController.stream;

  @override
  void dispose(){
    _favoriteAddController.close();
    _favoriteRemoveController.close();
    _favoriteTotalController.close();
    _favoritesController.close();
  }

  // ############# HANDLING  #####################

  void _handleAddFavorite(SerialCard movieCard){
    // Add the movie to the list of favorite ones
    _favorites.add(movieCard);

    _notify();
  }

  void _handleRemoveFavorite(SerialCard movieCard){
    _favorites.remove(movieCard);

    _notify();
  }

  void _notify(){
    // Send to whomever is interested...
    // The total number of favorites
    _inTotalFavorites.add(_favorites.length);

    // The new list of all favorite movies
    _inFavorites.add(UnmodifiableListView(_favorites));
  }
}
