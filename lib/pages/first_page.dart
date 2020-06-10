import 'package:flutter/material.dart';
import 'package:avideo/pages/auth/login.dart';

import '../sharedPref.dart';
import 'home.dart';

class FirstPage extends StatelessWidget {
  final Future<bool> futureAuth = SharedPref().getAuth();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController passwordController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return   FutureBuilder<bool>(
            future: futureAuth,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState==ConnectionState.done) {
                if (snapshot.hasData&&snapshot.data)
                  return HomePage(nameController: nameController, passwordController: passwordController);
                else
                  return LoginPage(nameController: nameController,
                      passwordController: passwordController);
              }
          else
            return const Center(child: CircularProgressIndicator());
       },
  );
  }


}