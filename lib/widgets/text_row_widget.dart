import 'package:flutter/material.dart';
import 'package:avideo/constants.dart';

class TextRowWidget extends StatelessWidget {
  const TextRowWidget( {
    Key key,
    this.showText,
    this.addWidget

  }) : super(key: key);

  final String showText;
  final dynamic addWidget;


  @override
  Widget build(BuildContext context) {

  return Column(
            children: <Widget>[
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color:  Constants.darkBlueColor,
                  boxShadow: [
                     const BoxShadow(
                      color: Constants.lightBlueColor,
                      blurRadius: 2.0, // has the effect of softening the shadow
                      spreadRadius: 2.0, // has the effect of extending the shadow
                      offset: Offset(
                        5.0, // horizontal, move right 10
                        5.0, // vertical, move down 10
                      ),
                    )
                  ],

                ),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('    '+ showText,style: Constants.Style18Text,),),
                          if (addWidget!=null) addWidget,
                      ],
                    )
                 ],)
                ,
              ),
              const SizedBox(height: 10),
            ],
          );

  }


}