import 'package:flutter/material.dart';
import 'package:avideo/constants.dart';

class ErrorRowWidget extends StatelessWidget {
  const ErrorRowWidget( {
    Key key,
    this.showText,
    this.color
  }) : super(key: key);

  final String showText;
  final Color color;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(  color:  color, borderRadius: BorderRadius.circular(5.0),),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text('     '+ showText,style: Constants.Style18Text,),),
                ],
              ),
              const SizedBox(height: 8),
            ],)
          ,
        ),
        const SizedBox(height: 10),
      ],
    );

  }


}