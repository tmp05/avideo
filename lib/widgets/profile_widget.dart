import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/sharedPref.dart';
import 'package:avideo/widgets/auth/email_field_widget.dart';
import 'package:avideo/widgets/auth/pass_field_widget.dart';
import 'package:avideo/widgets/error_row_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';

import '../common.dart';
import '../constants.dart';


class ProfileWidget extends StatelessWidget {
  ProfileWidget({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController passwordController;

  final FocusNode nameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final Future<dynamic> user = SharedPref().read('user');

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    final double width = MediaQuery.of(context).size.width<570.toDouble()?MediaQuery.of(context).size.width-20.toDouble():550.toDouble();
    user.then(( dynamic onValue){
      authBloc.addName(onValue!=null?onValue['email']:null);
      nameController.value = TextEditingValue(text:onValue!=null?onValue['email']:'');
    });

    nameController.addListener(() {
      authBloc.addName(nameController.text.trim());
    });

    return   Container(
        width: width,
        padding: const EdgeInsets.all(15.0),
    child:   Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const Text('..'),
                const TextRowWidget(showText: Constants.profileMenuText),
                StreamBuilder<String>(
                    stream: authBloc.curError,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData){
                        return ErrorRowWidget(showText:snapshot.data, color: Constants.greenColor);}
                      else
                        return Container();
                    }),
                Wrap (
                    children:<Widget>[
                  StreamBuilder<String>(
                      stream: authBloc.curName,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return EmailFieldWidget(data:snapshot.data,controller:nameController, focus:nameFocus);
                      }),
                  StreamBuilder<String>(
                      stream: authBloc.curPass,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return PassFieldWidget(data:snapshot.data, controller:passwordController, focus:passwordFocus,changePass: true,);
                      }),
                ]),
                RaisedButton(
                  color: Constants.greenColor,
                  onPressed: () {
                    if (nameController.text.trim().isEmpty||!Common().validateEmail(nameController.text))
                      authBloc.addName(nameController.text.trim());
                    if (passwordController.text.trim().isEmpty)
                      authBloc.addPass(passwordController.text.trim());
                    else {
                      AtotoApi().save(nameController.text, passwordController.text).then((String result){
                            authBloc.addError(result=='true'? Constants.saveDataText:result);
                          });
                      }},
                 child: const Text(
                    Constants.saveText,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
         ));

  }


}
