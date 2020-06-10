import 'package:flutter/material.dart';
import 'package:avideo/common.dart';
import 'package:avideo/constants.dart';



class EmailFieldWidget extends StatelessWidget {
  const EmailFieldWidget({
    Key key,
    this.data,
    this.controller,
    this.focus,
  }) : super(key: key);

  final String data;
  final TextEditingController controller;
  final FocusNode focus;

  Color getColor(String text, FocusNode focus) {
    if (focus.hasFocus) {//first focus
      return Constants.greenColor;
    }
    else if (text!=null && !Common().validateEmail(text)) {
      return Constants.errorColor;
    } else {
      return Constants.grayColor;
    }
  }

  String errorMessage(String text, String message) {
    if (focus.hasFocus) {
      return '';
    } else if (text!=null&&text.isEmpty) {
      return message;
    } else if (text!=null&&!Common().validateEmail(text)){
      return Constants.emailIsWrongText;
    }
    else {
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    const double width = 60.0;

    return  Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(child: const Icon(Icons.email)),
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
                  child: TextFormField(
                          obscureText:false,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          controller: controller,
                          focusNode: focus,
                          cursorColor: Colors.blueGrey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Constants.emailText,
                            labelStyle: TextStyle(
                              color: getColor(data, focus),
                            ),
                          ),
                        )
                )),

          ],
        ),
        Container(
          child: Text(
            errorMessage(data, Constants.emailIsNecessaryText),
            style: const TextStyle(color: Colors.redAccent),
          ),
        )
      ],
    );
  }
}
