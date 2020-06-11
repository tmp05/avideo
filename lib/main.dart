import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avideo/blocs/application_bloc.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/blocs/favorite_bloc.dart';
import 'package:avideo/pages/first_page.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
//  debugPrintRebuildDirtyWidgets = true;
  return runApp(
      BlocProvider<ApplicationBloc>(
        bloc: ApplicationBloc(),
        child: BlocProvider<FavoriteBloc>(
          bloc: FavoriteBloc(),
          child:  BlocProvider<AuthBloc>(
              bloc: AuthBloc(),
              child: MyApp(),
        ),
      )
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Atoto',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FirstPage(),
        navigatorObservers: [routeObserver],

    );
  }
}


