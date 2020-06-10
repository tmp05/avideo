import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/common.dart';
import 'package:avideo/constants.dart';
import 'package:avideo/pages/home.dart';
import 'package:avideo/widgets/auth/enter_button_widget.dart';
import 'package:avideo/widgets/auth/email_field_widget.dart';
import 'package:avideo/widgets/error_row_widget.dart';
import 'package:avideo/widgets/auth/pass_field_widget.dart';
import 'package:avideo/widgets/auth/promo_field_widget.dart';
import 'package:avideo/widgets/text_row_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController passwordController;

  final FocusNode nameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode promoFocus = FocusNode();


  final TextEditingController promoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    nameController.addListener(() {
      authBloc.addName(nameController.text.trim());
    });

    passwordController.addListener(() {
      authBloc.addPass(passwordController.text.trim());
    });

    passwordController.addListener(() {
      authBloc.addPromo(promoController.text.trim());
    });

    final double width = MediaQuery.of(context).size.width<570.toDouble()?MediaQuery.of(context).size.width-20.toDouble():550.toDouble();

    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: Align (
            alignment: Alignment.center,
              child: Container(
              width: width,
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextRowWidget(showText: Constants.registrationText,addWidget:EnterButtonWidget(nameController:nameController,passwordController:passwordController )),
                  StreamBuilder<String>(
                      stream: authBloc.curError,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData)
                          return ErrorRowWidget(showText:snapshot.data,color: Constants.orangeColor);
                        else
                          return Container();
                      }),
                  StreamBuilder<String>(
                      stream: authBloc.curName,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return EmailFieldWidget( data:snapshot.data, controller:nameController, focus:nameFocus);
                      }),
                  const SizedBox(height: 10),
                  StreamBuilder<String>(
                      stream: authBloc.curPass,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return PassFieldWidget(data:snapshot.data, controller:passwordController, focus:passwordFocus,);
                      }),
                  const SizedBox(height: 10),
                  StreamBuilder<String>(
                      stream: authBloc.curPromo,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return PromoFieldWidget(data:snapshot.data,controller:promoController,focus:promoFocus);
                      }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget>[
                      RaisedButton(
                        color: Constants.greenColor,
                        onPressed: () {
                          if (nameController.text.trim().isEmpty||!Common().validateEmail(nameController.text))
                            authBloc.addName(nameController.text.trim());
                          if (passwordController.text.trim().isEmpty)
                            authBloc.addPass(passwordController.text.trim());
                          else {
                            AtotoApi().register(nameController.text, passwordController.text, promoController.text).then((result)=>{
                              if (result.success){
                                authBloc.addError(null),
                                Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                                      return  HomePage(nameController: nameController, passwordController: passwordController);
                                }))}
                              else  authBloc.addError(result.error)
                            });
                          }
                        },
                        child: const Text(
                          Constants.acceptText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            )));
  }


}