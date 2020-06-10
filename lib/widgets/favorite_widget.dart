import 'package:flutter/material.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/favorite_bloc.dart';
import 'package:avideo/models/serial_card.dart';

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget({
    Key key,
    this.data,
  }) : super(key: key);

  final SerialCard data;

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.of<FavoriteBloc>(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black54,
          ),
        ),
      ),
      child: ListTile(
         title: Text(data.title),
        subtitle: Text(data.title, style: const TextStyle(fontSize: 10.0)),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red,),
          onPressed: (){
            bloc.inRemoveFavorite.add(data);
          },
        ),
      ),
    );
  }
}
