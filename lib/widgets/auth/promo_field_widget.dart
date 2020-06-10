import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/auth_bloc.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:avideo/constants.dart';



class PromoFieldWidget extends StatelessWidget {
  const PromoFieldWidget({
    Key key,
    this.data,
    this.controller,
    this.focus,
 }) : super(key: key);

  final String data;
  final TextEditingController controller;
  final FocusNode focus;

  Color getColor(String text, FocusNode focus,bool resultOfChecking) {
    if (!resultOfChecking) {
      return Constants.errorColor;
    }
    else  if (focus.hasFocus) {
      return Constants.greenColor;
    }
    else
      return Constants.grayColor;
  }

  String errorMessage(String text, String message,FocusNode focus, bool resultOfChecking) {
    if (!resultOfChecking) {
      return message;
    }
    if (focus.hasFocus) {
      return Constants.promoRequiredText;
    }
    else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return  Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(child: const Icon(Icons.priority_high)),
            Expanded(
                child: Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        bottom: BorderSide(
                          color: getColor(data, focus, true),
                          width: 1.0,)
                    ),
                  ),
                  child: StreamBuilder<bool>(
                      stream: authBloc.curCheck,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return Focus(
                           child:TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              controller: controller,
                              focusNode: focus,
                              cursorColor: Colors.blueGrey,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: Constants.promoText,
                                labelStyle: TextStyle(
                                  color: getColor(data, focus, snapshot.data==null||snapshot.data),
                                ),
                              ),
                              onEditingComplete: () {
                                _checkPromo(controller.text, authBloc);
                              },
                            ),
                          onFocusChange: (bool hasFocus) {
                            if(!hasFocus) {
                              _checkPromo(controller.text, authBloc);
                            }
                          },
                        );
                      }),
                )),
              IconButton(
                  icon:const Icon(Icons.keyboard_arrow_right),
                  onPressed:(){
                    _checkPromo(controller.text, authBloc);
                  }
              )
          ],
        ),
        Container(
          child:StreamBuilder<bool>(
          stream: authBloc.curCheck,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData)
               return Text (
                 errorMessage(data, Constants.promoIsWrongText, focus, snapshot.data),
                 style: const TextStyle(color: Constants.errorColor),
                 );
            else {
              return Text (
              errorMessage(data, Constants.promoIsWrongText, focus, true),
              style: const TextStyle(color: Constants.grayColor),
            );}

          }),
        )
      ],
    );
  }


  void _checkPromo(String text, AuthBloc authBloc){
    if (text.isNotEmpty)
      AtotoApi().checkPromo(text).then((bool onValue){
        if (onValue!=null) {
          authBloc.checkPromo(onValue);
        }});

  }

}
