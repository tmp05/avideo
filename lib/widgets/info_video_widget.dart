import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:avideo/models/movie_info.dart';
import 'package:avideo/models/serial_card.dart';
import 'package:avideo/widgets/image_widget.dart';

class InfoVideoWidget extends StatelessWidget {
  const InfoVideoWidget( {
    Key key,
    this.data,
    this.style,
    this.serial
  }) : super(key: key);

  final MovieInfo data; //MovieInfo or MoviesInfo
  final TextStyle style;
  final SerialCard serial;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Hero(
          child: ImageWidget(section: 'channel',id:serial.id ,photo: serial.photo),
          tag: 'movie_${serial.id}',
        ),
        const SizedBox(height: 10.0),
        Text('Рейтинг: ${serial.kinopoisk}',style: style),
        Text('Год: ${data.movieYear}',style: style),
        Text('Страна: ${data.country}',style: style),
        Container(
          padding: const EdgeInsets.only(left: 15.0),
          child:  ExpandableNotifier(
            initialExpanded: false,
            child: ExpandablePanel(
              header: Text('Описание',style: style,),
              collapsed: Text(data.descr, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(data.descr, softWrap: true, overflow: TextOverflow.fade,)
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }


}
