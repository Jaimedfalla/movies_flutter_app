import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';
import '../models/models.dart';

class CastingCards extends StatelessWidget {

  final int movieId;

  const CastingCards(this.movieId, {super.key});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context,listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCasting(movieId),
      builder: (context, snapshot) {
        if( !snapshot.hasData ) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CircularProgressIndicator(),
          );
        }

        final casting = snapshot.data!;

        return Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.only(bottom: 30),
          child: ListView.builder(
            itemCount: casting.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return _CastCard(casting[index]);
            },
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;

  const _CastCard(this.cast);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(cast.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            )
          ),
          const SizedBox(height: 5),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}