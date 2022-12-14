import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_flutter_app/models/models.dart';
import 'package:movies_flutter_app/providers/abstract_provider.dart';

class MoviesProvider with ChangeNotifier implements Searcheable<Movie>{

  final String _apiKey   = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl  = 'api.themoviedb.org';
  final String _language = 'es-Es';
  List<Movie> movies = [];
  List<Movie> popularMovies = [];
  Map<int,List<Cast>> moviesCast = {};
  int _popularPage = 0;

  MoviesProvider() {
      getOnNowPlayingMovies();
      getPopularMovies();
  }

  Future<String>_getJsonData({
    String resource='',
    String segment='',
    Map<String,String> parameters=const {}
  }) async{

    final Map<String,String> params ={
      'api_key':_apiKey,
      'language':_language
    };

    if(parameters.isNotEmpty) params.addAll(parameters);
    Uri url = Uri.https(_baseUrl,'3/${segment}movie$resource',parameters);

    var response = await http.get(url);

    return response.body;
  }

  getOnNowPlayingMovies() async {
    _popularPage = 1;
    final jsonData = await _getJsonData(resource:'/now_playing',parameters: {'page':'$_popularPage'});

    final nowPlaying = NowPlayingResponse.fromJson(jsonData);
    movies = nowPlaying.results;

    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;
    final jsonData = await _getJsonData(resource:'/popular', parameters: {'page':'$_popularPage'});

    final nowPlaying = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...nowPlaying.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCasting(int movieId) async{
    List<Cast>? cast = moviesCast[movieId];
    if(moviesCast.isEmpty){
      final jsonData =   await _getJsonData(resource:'$movieId/credits');
      final casting = MovieCasting.fromJson(jsonData);
      cast = [...casting.cast];
      moviesCast[movieId]=cast;
    }

    return cast??[];
  }

  @override
  Future<List<Movie>> search(String query) async{
    if(query.isNotEmpty){
      final jsonData =   await _getJsonData(segment:'/search/',parameters: {'query':query});
      final results = SearchResponse.fromJson(jsonData);

      return results.results;
    }

    return [];
  }
}