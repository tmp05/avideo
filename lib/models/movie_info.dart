import 'package:avideo/models/enums/video_info.dart';
import 'enums/seasons_list.dart';
import 'enums/video_list.dart';

class MovieInfo extends Object {
  MovieInfo(this.id, this.title, this.address, this.descr, this.tags, this.photo, this.movieId,this.movieYear, this.personCache, this.actor,this.fave, this.country,this.kinopoisk, this.productionCompany, this.genres, this.seasons, this.videos,this.videoInfo);

  MovieInfo.fromJSON(Map<String, dynamic> json)
      : id = json['channel']['id'],
        title = json['channel']['title'],
        address = json['channel']['address'],
        descr = json['channel']['description'].replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"'),
  //descr = json['channel']['description'],
        tags = json['channel']['tags'],
        photo = json['channel']['photo'],
        movieId = json['channel']['movie']['id'],
        movieYear = json['channel']['movie']['year'],
        personCache ='', //json['channel']['person_cache'],
        actor = '',//json['channel']['actor'],
        fave = json['fave'],
        kinopoisk = json['channel']['rating']!=null?json['channel']['rating']['kinopoisk'].toString():'-',
        country = json['channel']['movie']['country'],
        productionCompany = '',//json['channel']['movie']['production_company'],
        genres = '',
        seasons= SeasonsList.fromJSON( json['seasons']),
        videoInfo = json['movie']==null?null:VideoInfo.fromJSON(json['movie']),
        videos = VideoList.fromJSON(json['video']);

  final int id;
  final String title;
  final String address;
  final String descr;
  final String tags;
  final dynamic photo;
  final int movieId;
  final int movieYear;
  final String personCache;
  final String actor;
  final dynamic fave;
  final String country;
  final String kinopoisk;
  final String productionCompany;
  final String genres;
  final SeasonsList seasons;
  final VideoList videos;
  final VideoInfo videoInfo;

  @override
  bool operator==(dynamic other) => identical(this, other) || id == other.id;

  @override
  int get hashCode => id;
}
