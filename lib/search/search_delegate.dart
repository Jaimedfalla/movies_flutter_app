import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../providers/abstract_provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  final Searcheable<Movie> _provider;
  final Widget _emptyContainer = const Center(child: Icon(Icons.movie_creation_outlined,color: Colors.black38,size: 130));

  MovieSearchDelegate(this._provider);

  @override
  String? get searchFieldLabel => 'Search movie';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query ='',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: ()=> close(context, null), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) return _emptyContainer;

    return FutureBuilder(
      builder: (_,AsyncSnapshot<List<Movie>> snapshot) {
        if(!snapshot.hasData) return _emptyContainer;

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, index) {
            return _MovieResultItem(movies[index]);
          },
        );
      },
      future: _provider.search(query),
    );
  }
}

class _MovieResultItem extends StatelessWidget {

  final Movie _movie;

  const _MovieResultItem(this._movie);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        image: NetworkImage(_movie.fullPosterImg),
        placeholder: const AssetImage('assets/images/loading.gif'),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(_movie.title),
      subtitle: Text(_movie.originalTitle),
      onTap: () => Navigator.,
    );
  }
}