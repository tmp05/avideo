import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/favorite_bloc.dart';
import 'package:avideo/blocs/favorite_movie_bloc.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:avideo/widgets/image_widget.dart';

class MovieCardWidget extends StatefulWidget {
  const MovieCardWidget({
    Key key,
    @required this.serialCard,
    @required this.favoritesStream,
    @required this.onPressed,
    this.noHero = false,
  }) : super(key: key);

  final SerialCard serialCard;
  final VoidCallback onPressed;
  final Stream<List<SerialCard>> favoritesStream;
  final bool noHero;

  @override
  MovieCardWidgetState createState() => MovieCardWidgetState();
}

class MovieCardWidgetState extends State<MovieCardWidget> {
  FavoriteMovieBloc _bloc;

  ///
  /// In order to determine whether this particular Movie is
  /// part of the list of favorites, we need to inject the stream
  /// that gives us the list of all favorites to THIS instance
  /// of the BLoC
  ///
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  ///
  /// As Widgets can be changed by the framework at any time,
  /// we need to make sure that if this happens, we keep on
  /// listening to the stream that notifies us about favorites
  ///
  @override
  void didUpdateWidget(MovieCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  void _createBloc() {
    _bloc = FavoriteMovieBloc(widget.serialCard);

    // Simple pipe from the stream that lists all the favorites into
    // the BLoC that processes THIS particular movie
    _subscription = widget.favoritesStream.listen(_bloc.inFavorites.add);
  }

  void _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);
    final List<Widget> children = <Widget>[
      ClipRect(
        clipper: _SquareClipper(),
        child: widget.noHero ?
                  ImageWidget(section: 'channel',id:widget.serialCard.id,photo: widget.serialCard.photo)
              : Hero(
                  child: ImageWidget(section: 'channel',id:widget.serialCard.id,photo: widget.serialCard.photo) ,
                  tag: 'movie_${widget.serialCard.id}',
          ),
      ),
      Container(
        decoration: _buildGradientBackground(),
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: _buildTextualInfo(widget.serialCard),
      ),
    ];

    //
    // If the movie is part of the favorites, put an icon to indicate it
    // A better way of doing this, would be to create a dedicated widget for this.
    // This would minimize the rebuild in case the icon would be toggled.
    // In this case, only the button would be rebuilt, not the whole movie card widget.
    //
    children.add(
      StreamBuilder<bool>(
          stream: _bloc.outIsFavorite,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onTap: () {
                        bloc.inRemoveFavorite.add(widget.serialCard);
                      },
                    )),
              );
            }
            return Container();
          }),
    );

    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: children,
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(SerialCard serialCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          serialCard.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          serialCard.kinopoisk,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return  Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
