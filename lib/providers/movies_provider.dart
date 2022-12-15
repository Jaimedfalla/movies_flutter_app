import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_flutter_app/helpers/debouncer.dart';
import 'package:movies_flutter_app/models/models.dart';
import 'package:movies_flutter_app/providers/abstract_provider.dart';

class MoviesProvider with ChangeNotifier implements Searcheable<Movie>{

  final String _apiKey   = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl  = 'api.themoviedb.org';
  final String _language = 'es-ES';
  List<Movie> movies = [];
  List<Movie> popularMovies = [];
  Map<int,List<Cast>> moviesCast = {};
  int _playing = 1;
  int _popularPage = 0;
  final Debouncer debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
  
  @override
  Stream<List<Movie>> get suggestionsStream => _suggestionsStreamController.stream;

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
    Uri url = Uri.https(_baseUrl,'3/${segment}movie$resource',params);

    var response = await http.get(url);
    return response.body;
  }

  getOnNowPlayingMovies() async {
    final jsonData = await _getJsonData(resource:'/now_playing',parameters: {'page':'$_playing'});

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
      final jsonData =   await _getJsonData(resource:'/$movieId/credits');
      final casting = MovieCasting.fromJson(jsonData);
      cast = [...casting.cast];
      moviesCast[movieId]=cast;
    }

    return cast??[];
  }

  Future<List<Movie>> search(String query) async{
    if(query.isNotEmpty){
      final jsonData =   await _getJsonData(segment:'/search/',parameters: {'query':query});
      final results = SearchResponse.fromJson(jsonData);

      return results.results;
    }

    return [];
  }

  @override
  void getSuggestonByQuery(String query){
    debouncer.value = '';
    debouncer.onValue = (value)async{
      final results = await search(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}