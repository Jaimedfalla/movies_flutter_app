import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_flutter_app/models/models.dart';

class MoviesProvider with ChangeNotifier{

  final String _apiKey   = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl  = 'api.themoviedb.org';
  final String _language = 'es-Es';
  List<Movie> movies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;

  MoviesProvider() {
      getOnNowPlayingMovies();
      getPopularMovies();
  }

  Future<String>_getJsonData(String segment) async{
    Uri url = Uri.https(_baseUrl,'3/movie/$segment',{
      'api_key':_apiKey,
      'language':_language,
      'page':'$_popularPage'
    });

    var response = await http.get(url);

    return response.body;
  }

  getOnNowPlayingMovies() async {
    _popularPage = 1;
    final jsonData = await _getJsonData('now_playing');

    final nowPlaying = NowPlayingResponse.fromJson(jsonData);
    movies = nowPlaying.results;

    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;
    final jsonData = await _getJsonData('popular');

    final nowPlaying = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...nowPlaying.results];

    notifyListeners();
  }
}