import 'package:flutter/material.dart';
import 'package:avideo/api/atoto_api.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget( {
    Key key,
    this.id,
    this.photo,
    this.preview,
    this.size,
    this.url,
    this.section
  }) : super(key: key);

  final String photo;
  final int preview;
  final int size;
  final String url;
  final int id;
  final String section;

  @override
  Widget build(BuildContext context) {
    String path;
    if (section =='channel'){
     path = api.imageUrl+ section + '/' + id.toString() + '/'+ photo + '_150.jpg';
    }
    else
    {
      final String size = this.size!=null?this.size.toString():'_';
      final String postfix = preview > 1 ? '_' + preview.toString() : '';
      path = api.imageVideoUrl + photo+'/'+size+postfix+'.jpg';
    }

    return Image.network(path,fit: BoxFit.cover);
  }


}


