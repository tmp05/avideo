import 'package:avideo/models/auth_result.dart';
import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/common.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/pages/auth/login.dart';
import 'package:avideo/widgets/error_row_widget.dart';
import 'package:avideo/widgets/auth/email_field_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';

class RestorePage extends StatelessWidget {
  const RestorePage({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController passwordController;



  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    final FocusNode nameFocus = FocusNode();

    nameController.addListener(() {
      authBloc.addName(nameController.text.trim());
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
                  const TextRowWidget(showText: Constants.restoreText),
                  StreamBuilder<String>(
                      stream: authBloc.curError,
                      builder: (BuildContext context, AsyncSnapshot<String>  snapshot) {
                        if (snapshot.hasData)
                          return StreamBuilder<bool>(
                        stream: authBloc.curSuccess,
                        builder: (BuildContext context, AsyncSnapshot<bool>  snapshotS) {
                          return   ErrorRowWidget(showText:snapshot.data, color: snapshotS.hasData&&snapshotS.data?Constants.greenColor:Constants.orangeColor);
                        });
                        else
                          return Container();
                      }),
                  StreamBuilder<String>(
                      stream: authBloc.curName,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return EmailFieldWidget(data:snapshot.data,controller:nameController, focus:nameFocus);
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                      RaisedButton(
                        color: Constants.whiteColor,
                        onPressed: () {
                          authBloc.addError(null);
                          authBloc.addSuccess(false);
                          Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                            return  LoginPage(nameController:nameController, passwordController:passwordController);
                          }));
                        },
                        child: const Text(  Constants.backText,
                          style: TextStyle(color: Constants.blackColor),
                        ),
                      ),
                      StreamBuilder<bool>(
                          stream: authBloc.curSuccess,
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData&&snapshot.data)
                              return Container();
                              else
                                return
                                RaisedButton(
                                    color: Constants.greenColor,
                                    onPressed: () {
                                      if (nameController.text.trim().isEmpty||!Common().validateEmail(nameController.text))
                                        authBloc.addName(nameController.text.trim());
                                      else {
                                        AtotoApi().resetPassword(nameController.text).then((AuthResult result){
                                          authBloc.addSuccess(result.success);
                                          authBloc.addError(result.success?result.result:result.error);
                                        });
                                      }
                                    },
                                    child: const Text(
                                      Constants.recoverPasswordText,
                                      style: TextStyle(color: Colors.white),
                                    ),
                              );
                          }),
                    ],
                  ),
                ],
              ),
            )));
  }
}