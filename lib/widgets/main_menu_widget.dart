import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/movie_catalog_bloc.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/pages/auth/login.dart';
import 'package:avideo/pages/list.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget( {
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);


  final TextEditingController nameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return
        Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
          children:           <Widget>[
            actionChips(Constants.filmText, const Icon(Icons.computer), 'movie',  context),
            actionChips(Constants.serialText, const Icon(Icons.view_headline),'series',context),
            actionChips(Constants.animeText, const Icon(Icons.view_headline),'anime',context),
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
            color: Colors.white, style: BorderStyle.solid, width: 1),
            ),
            child:  DropdownButton<Item>(
                 onChanged: ( Item value) {
                   _actionItem(value.name, context);
                 },
                 hint: const Text(Constants.customText),
                     items: Constants.items.map((Item item) {
                   return  DropdownMenuItem<Item>(
                     value: item,
                     child: Row(
                   children: <Widget>[
                   item.icon,
                   const SizedBox(width: 5,),
                   Text(item.name,style:  const TextStyle(color: Constants.blackColor)),
                   ],
                     ),
                   );
                 }).toList(),
               )),
        ],);



  }

  Widget actionChips(String text, Icon icon, String section, BuildContext context) {

    return ActionChip(
      elevation: 6.0,
      avatar: CircleAvatar(
        backgroundColor: Colors.green[60],
        child: icon,
      ),
      label: Text(text),
      onPressed: () {
        _openPage(section, context);
      },
      backgroundColor: Colors.white,
    );
  }

  void _openPage(String section, BuildContext context) {
    Navigator
        .of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return BlocProvider<MovieCatalogBloc>(
        bloc: MovieCatalogBloc(),
        child: ListPage(section:section),
      );
    }));
  }

  void _actionItem(String name, BuildContext context) {
    switch (name){
      case Constants.exitText:
        AtotoApi().logOut().then((bool onValue){
          if (onValue)
                Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.addError(null);
                  return LoginPage(nameController: nameController,passwordController: passwordController,);
                }));
        });
        break;
    }

  }
}
