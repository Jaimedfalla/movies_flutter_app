import 'package:flutter/material.dart';
import 'package:movies_flutter_app/providers/movies_provider.dart';
import 'package:movies_flutter_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    /* La propiedad listen indica al widget que se redibuje cuando el provider haga el llamaod de NotifyListeners.
    * Por defecto está en true*/
    final moviesProvider = Provider.of<MoviesProvider>(context,listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Playing'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.movies),
            MovieSlider(
              popularMovies: moviesProvider.popularMovies,
              title: 'Popular Movies',
              nextPage: () => moviesProvider.getPopularMovies(),
            )
          ],
        ),
      ),
    );
  }
}