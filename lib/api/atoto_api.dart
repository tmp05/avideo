import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avideo/models/enums/genre.dart';
import 'package:http/http.dart' as http;
import 'package:avideo/constants.dart';
import 'package:avideo/models/auth_result.dart';
import 'package:avideo/models/enums/full_video_info.dart';
import 'package:avideo/models/enums/genres_list.dart';
import 'package:avideo/models/enums/video_list.dart';
import 'package:avideo/models/serial_page_result.dart';
import 'package:avideo/models/movie_info.dart';
import '../sharedPref.dart';

class AtotoApi {

  static const String baseUrl = 'atoto.ru';
  final String imageUrl = 'https://image.atoto.ru/';
  final String imageChannelUrl = 'https://image.atoto.ru/channel/';
  final String imageVideoUrl = 'https://image.atoto.ru/video/';
  SharedPref sharedPref = SharedPref();

  final HttpClient _httpClient =  HttpClient();
  ///
  /// Returns the list of movies/tv-show, based on criteria:
  /// [section]: movie or tv (show)
  /// [pageIndex]: page
  /// [minYear, maxYear]: release dates range
  /// [genre]: genre
  ///
  Future<SerialPageResult> pagedList({String section,SortItem sort, int pageIndex= 1, int minYear= 2000, int maxYear= 2019, Genre genre}) async {
    String sortId = sort!=null?sort.id:'';
    Map<String,dynamic> data = {
      'section': [section],
      'sort':'$sortId',
      'page': '$pageIndex'
    };
    if (genre!=null) data.addAll({'category': [genre.id]});
    print(data);
    var body = json.encode(data);

    final String response = await _getHttpRequest('https://atoto.ru/api/channel/list','post',body:body);
    final SerialPageResult list = SerialPageResult.fromJSON(json.decode(response));

    return list;
  }

  Future<MovieInfo> makeRequestMovie(String query) async {
    MovieInfo result;

    final Uri uri = Uri.https(
      baseUrl,
      'api/channel/item/'+query,
    );
    final String response = await _getRequest(uri,'get');
    result = MovieInfo.fromJSON(json.decode(response));

    return result;
  }

  Future<VideoList> makeRequestVideoList(dynamic data) async {
    if (data.runtimeType == String) {
      //this is an address to get videos from api
      final Uri uri = Uri.https(
        baseUrl,
        'api/channel/season/'+data,
      );
        final String response = await _getRequest(uri,'get');
      final VideoList info = response!=null?VideoList.fromJSON(json.decode(response)['video']):null;

      return info;
    }
    else {
      //this is the list of videos, we don't need to do anything
      return data;
    }

  }

  Future<FullVideoInfo> makeRequestFullVideoInfo(int id) async {
    final Uri uri = Uri.https(
      baseUrl,
      'api/video/'+id.toString(),
    );
    final String response = await _getRequest(uri,'get');
    final FullVideoInfo info = response!=null?FullVideoInfo.fromJSON(json.decode(response)):null;
    return info;
  }

  ///
  /// Returns the list of all genres
  ///
  Future<GenresList> movieGenres({String type='movie'}) async {
    final Uri uri = Uri.https(
      baseUrl,
      'api/getCategories',
     );
    final String response = await _getRequest(uri,'get');
    final GenresList list = GenresList.fromJSON(json.decode(response));

    return list;
  }


  Future<int> getVideoNext(int videoId, int seasonId, String direction) async {
    final Uri uri = Uri.https(
      baseUrl,
      'api/video-next', {'video_id':videoId.toString(),'channel_id':seasonId.toString(),'direction':direction}
    );
    final String response = await _getRequest(uri,'post');
    final Map<String, dynamic> json = jsonDecode(response);

    return json['v_id'];
  }


  Future<AuthResult> authenticate(String username, String password) async {
    AuthResult authResult;
    final Uri uri = Uri.https(
        baseUrl,
        'api/login',
        {'email':username,'password':password}
    );
    final String response = await _getRequest(uri,'post');
    final Map<String, dynamic> parsed = json.decode(response);

    if (response.contains('error'))
      authResult =  AuthResult(false, '', parsed['error']);
    else {
      final AuthUser user = AuthUser.fromJSON(parsed['user']);
      saveSharedPrefs(user, parsed['token']);
      authResult= AuthResult(parsed['success'], parsed['token'],'');
    }
    return authResult;
  }

  Future<bool> checkPromo(String promo) async {
    bool authResult;
    final Uri uri = Uri.https(
        baseUrl,
        '/api/promo/check-reg/'+promo
    );
    final String response = await _getRequest(uri,'get');
    if (response.contains('success'))
      authResult =  true;
    else {
      authResult = false;
    }
    return authResult;
  }

  Future<AuthResult> resetPassword(String email) async {
    AuthResult authResult;


    final Uri uri = Uri.https(
        baseUrl,
        'api/reset/send',{'email':email}
    );
    final String response = await _getRequest(uri,'post');
    final Map<String, dynamic> parsed = json.decode(response);

    if (response.contains('error'))
      authResult =  AuthResult(false, '', parsed['error']);
    else {
      authResult =  AuthResult(true, parsed['success'], '');
    }
    return authResult;
  }


  Future<AuthResult> register(String email, String password, String promo) async {
    AuthResult authResult;

    final Uri uri = Uri.https(
        baseUrl,
        'api/register', {'email':email,'password':password,'promo':promo}
    );
    final String response = await _getRequest(uri,'post');
    final Map<String, dynamic> parsed = json.decode(response);

    if (response.contains('errors')) {
      authResult =  AuthResult(false, '', parsed['errors']['email']);
    }
    else {
      final AuthUser user =  AuthUser.fromJSON(parsed['user']);
      saveSharedPrefs(user, parsed['token']);
      authResult=  AuthResult(parsed['success'], parsed['token'],'');
    }
    return authResult;
  }

  Future<String> getProvider(String provider) async {

    final Uri uri = Uri.https(
        baseUrl,
        'api/oauth/'+provider+'/url'
    );
    final String response = await _getRequest(uri,'get');
    final Map<String, dynamic> parsed = json.decode(response);
    return parsed['url'];
  }

  Future<AuthResult> getAuthUser(String code) async {
    AuthResult authResult;

    final Uri uri =Uri.parse(code);
    final String response = await _getRequest(uri,'get');
    final Map<String, dynamic> parsed = json.decode(response);

    if (response.contains('error')) {
      authResult = AuthResult(false, '', parsed['error']);
    }
    else {
      final AuthUser user = AuthUser.fromJSON(parsed['user']);
      saveSharedPrefs(user, parsed['token']);
      authResult = AuthResult(parsed['success'], parsed['token'],'');
    }

    return authResult;
  }

  Future<bool> logOut() async {
    bool result;
    final Uri uri = Uri.https(
      baseUrl,
      'api/logout',
    );
    final String response = await _getRequest(uri,'get');
    final Map<String, dynamic> parsed = json.decode(response);

    if (response.contains('error')) {
      result =  false;
    }
    else {
      result= parsed['success'];
      sharedPref.save('auth', !result);
    }

    return result;
  }

  Future<String> save(String username, String password) async {
    String result;
    final Uri uri = Uri.https(
        baseUrl,
        '/api/user/save', {'email':username,'password':password}
    );
    final String response = await _getRequest(uri,'post');
    final Map<String, dynamic> parsed = json.decode(response);
    if (response.contains('errors'))
      result =  parsed['errors']['email'].toString();
    else
      result =  parsed['success'].toString();
    return result;
  }

  Future<bool> markVideoAsSeen(String id) async {
    bool markResult;
    final Uri uri = Uri.https(
        baseUrl,
        ' api/video/'+id+'/mark'
    );
    final String response = await _getRequest(uri,'get');
    if (response.contains('success'))
      markResult =  true;
    else {
      markResult = false;
    }
    return markResult;
  }


  ///
  /// Routine to invoke atoto Server to get answers
  ///
  ///
  Future<String> _getHttpRequest(String url, String typeofRequest,{dynamic body}) async {
    http.Response response;
    Map<String,String> httpHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};

    final String token = await sharedPref.read('token');
    if (token!=null) {

      final Map<String,String> cookies = {'Cookie': 'token='+token};
      httpHeaders.addAll(cookies);
    }

    if (typeofRequest=='post')
        response = await http.post(
             url,
            headers: httpHeaders,
            body:  body,
            encoding: Encoding.getByName("utf-8")
    );
    else
        response = await http.get(
          url,
          headers: httpHeaders,
      );
    return response.statusCode == 200?response.body:null;
  }

  Future<String> _getRequest(Uri uri, String typeofRequest) async {
    HttpClientResponse response;

    final HttpClientRequest request = typeofRequest=='get'?await _httpClient.getUrl(uri):await _httpClient.postUrl(uri);


    final String token = await sharedPref.read('token');
    if (token!=null) {
      final List<Cookie> cookies = [Cookie('token', token)];
      request.cookies.addAll(cookies);
    }

    try {
      response = await request.close();

    }catch (error) {
      throw Exception(Constants.errorRequest);
    }
    return response.statusCode == 200?response.transform(utf8.decoder).join():null;
  }

  void saveSharedPrefs(AuthUser user, String token) {
    sharedPref.save('user', user.toJson());
    sharedPref.save('token', token);
    sharedPref.save('auth', true);

  }
}

AtotoApi api = AtotoApi();
