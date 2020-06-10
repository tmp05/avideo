import 'package:flutter/material.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/constants.dart';



class PassFieldWidget extends StatelessWidget {
  const PassFieldWidget({
    Key key,
    this.data,
    this.controller,
    this.focus,
    this.changePass=false
  }) : super(key: key);

  final String data;
  final TextEditingController controller;
  final FocusNode focus;
  final bool changePass;


  Color getColor(String text, FocusNode focus) {
    if (focus.hasFocus) { // focus + first show
      return Constants.greenColor;
    }
    else if (text != null&&text.isEmpty) { //focus + entering something
      return Constants.errorColor;
    }else {
      return Constants.grayColor;
    }
  }

  String errorMessage(String text, String message,FocusNode focus) {
    if (focus.hasFocus) {
      return '';
    } else if (text != null&&text.isEmpty) {
      return message;
    }
    else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    const double width = 60.0;
    return  Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(child: const Icon(Icons.https)),
            Expanded(
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        bottom: BorderSide(
                          color: getColor(data, focus),
                          width: 1.0,)
                    ),
                  ),
                  child: StreamBuilder<bool>(
                      stream: authBloc.curSecure,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return TextFormField(
                          obscureText:snapshot.data??false,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          controller: controller,
                          focusNode: focus,
                          cursorColor: Colors.blueGrey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: changePass?Constants.changePasswordText:Constants.passwordText,
                            labelStyle: TextStyle(
                              color: getColor(data, focus),
                            ),
                          ),
                        );
                      }),
                )),
              StreamBuilder<bool>(
                  stream: authBloc.curSecure,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return IconButton(
                        icon:snapshot.data??false? const Icon(Icons.visibility):const Icon(Icons.visibility_off),
                        onPressed:(){authBloc.changeSecure(snapshot.data??false);}
                    );
                  }),
          ],
        ),
        Container(
          child: Text(
            errorMessage(data, Constants.fieldIsNecessaryText, focus),
            style: const TextStyle(color: Colors.redAccent),
          ),
        )
      ],
    );
  }
}
