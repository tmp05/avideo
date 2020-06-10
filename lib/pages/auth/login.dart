import 'package:avideo/models/auth_result.dart';
import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/common.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/pages/home.dart';
import 'package:avideo/pages/auth/restore_page.dart';
import 'package:avideo/widgets/auth/email_field_widget.dart';
import 'package:avideo/widgets/auth_service_widget.dart';
import 'package:avideo/widgets/error_row_widget.dart';
import 'package:avideo/widgets/auth/pass_field_widget.dart';
import 'package:avideo/widgets/auth/register_button_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);


  final TextEditingController nameController;
  final TextEditingController passwordController;

  final FocusNode nameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();



  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    nameController.addListener(() {
      authBloc.addName(nameController.text.trim());
    });

    passwordController.addListener(() {
      authBloc.addPass(passwordController.text.trim());
    });

    final double width = MediaQuery.of(context).size.width<570.toDouble()?MediaQuery.of(context).size.width-20.toDouble():550.toDouble();

     return Scaffold(
       resizeToAvoidBottomPadding: false,
       body: Align (
          alignment: Alignment.center,
           child: Container(
             width: width,
             padding: const EdgeInsets.all(15.0),
             child: Column(
                 mainAxisAlignment:MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: <Widget>[
                    TextRowWidget(showText: Constants.enterText, addWidget:RegisterButtonWidget(nameController:nameController,passwordController:passwordController )),
                   StreamBuilder<String>(
                       stream: authBloc.curUrl,
                       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                         if (snapshot.hasData) {
                           AtotoApi().getAuthUser(snapshot.data).then((AuthResult result) async {
                             authBloc.addUrl(null);
                             if (result.success){
                               authBloc.addError(null);
                                 Navigator.of(context).push(
                                 MaterialPageRoute<void>(builder: (BuildContext context) {
                                   return  HomePage(nameController: nameController, passwordController: passwordController);
                                 }));
                             }
                             else
                               authBloc.addError(result.error=='redirect'?null:'Ошибка доступа');
                           });
                         }
                         return Container();
                       }),
                    StreamBuilder<String>(
                        stream: authBloc.curError,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData){
                           return ErrorRowWidget(showText:snapshot.data,color: Constants.orangeColor);}
                          else
                            return Container();
                        }),
                   const AuthServiceWidget(),
                   StreamBuilder<String>(
                        stream: authBloc.curName,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return EmailFieldWidget(data:snapshot.data,controller:nameController, focus:nameFocus);
                        }),
                    const SizedBox(height: 10),
                    StreamBuilder<String>(
                        stream: authBloc.curPass,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return PassFieldWidget(data:snapshot.data, controller:passwordController, focus:passwordFocus);
                          }),

                   const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        RaisedButton(
                          color: Constants.orangeColor,
                          onPressed: () {
                            authBloc.addError(null);
                            Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                              return  RestorePage(nameController: nameController, passwordController: passwordController,);
                            }));
                          },
                          child: const Text(  Constants.recoverPasswordText,
                            style: TextStyle(color: Constants.whiteColor),
                          ),
                        ),
                          RaisedButton(
                          color: Constants.greenColor,
                          onPressed: () {
                            if (nameController.text.trim().isEmpty||!Common().validateEmail(nameController.text))
                                authBloc.addName(nameController.text.trim());
                            if (passwordController.text.trim().isEmpty)
                              authBloc.addPass(passwordController.text.trim());
                           else {
                              AtotoApi().authenticate(nameController.text, passwordController.text).then((AuthResult result){
                                if (result.success){
                                  authBloc.addError(null);
                                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                                    return  HomePage(nameController: nameController, passwordController: passwordController);
                                  }));
                                }
                                else
                                  authBloc.addError(result.error);
                              });
                            }
                          },
                          child: const Text(
                            Constants.enter2Text,
                            style: TextStyle(color: Colors.white),
                          ),
                          ),
                      ],
                    ),
                  ],
                ),
      )));
  }



}

