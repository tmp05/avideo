import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';

import '../../constants.dart';

const userAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key, this.urlString}): super(key: key);

  final String urlString;


  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void dispose() {
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    flutterWebviewPlugin.close();


    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (state.url.startsWith('https://atoto.ru/oauth/')) {           //like  https://atoto.ru/api/oauth/vkontakte?code=cd9134e8a31ec263a5
            flutterWebviewPlugin.stopLoading();
            flutterWebviewPlugin.dispose();
            final url = state.url.replaceAll('/oauth/', '/api/oauth/');
            authBloc.addUrl(url);
            Navigator.pop(context);
          }
      });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
            child: WebviewScaffold(
            url: widget.urlString,
            userAgent: userAgent,
            initialChild: Container(
            color: Constants.whiteColor,
              child: const Center(
               child: Text('Loading.....'),
                ))
       )
      )
     );
  }
}
