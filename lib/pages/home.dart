import 'package:flutter/material.dart';
import 'package:avideo/widgets/main_menu_widget.dart';
import 'package:avideo/widgets/profile_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        body:  CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: MainMenuWidget()),
              SliverToBoxAdapter(
                  child: ProfileWidget(nameController: nameController,passwordController: passwordController,)),
       ]
    ));
  }


}
