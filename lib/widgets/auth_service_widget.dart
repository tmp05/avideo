import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/pages/auth/auth_screen.dart';



class AuthServiceWidget extends StatelessWidget {
  const AuthServiceWidget( {
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget>[
          Container(width: 10,),
          InkWell(
              child: const ImageIcon(
                  AssetImage('assets/google_logo.png'),
                  color: Constants.darkBlueColor),
              onTap: () {_getProviderToken ('google',context);}
          ),
          Container(width: 10,),
          InkWell(
              child: const ImageIcon(
                  AssetImage('assets/vk_logo.png'),
                  color: Constants.darkBlueColor),
              onTap: () {_getProviderToken ('vkontakte',context);}
          )
        ]
      ));
  }

  void _getProviderToken  (String provider, BuildContext context) {
    AtotoApi().getProvider(provider).then((String onValue) =>
    {
      Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (BuildContext context) {
            return AuthScreen(urlString: onValue,);
          }))
    });
  }
}