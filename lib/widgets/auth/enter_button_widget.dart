import 'package:flutter/material.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/pages/auth/login.dart';
import '../../constants.dart';



class EnterButtonWidget extends StatelessWidget {
  const EnterButtonWidget({
    Key key,
    this.nameController,
    this.passwordController
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Row (
      children: <Widget>[
          Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Constants.whiteColor)
          ),
          child: FlatButton(
                  child:const Text(Constants.enter2Text, style: Constants.Style14Text),
                  onPressed: () {
                    authBloc.addError(null);
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                      return  LoginPage(nameController:nameController, passwordController:passwordController);
                    }));
                  },),

        ),
        const SizedBox(width: 10,)
    ],);
  }
}
