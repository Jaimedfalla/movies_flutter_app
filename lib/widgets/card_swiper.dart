import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({
    super.key, 
    required this.movies
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if(movies.isEmpty){
      return Container(
        width: double.infinity,
        height: size.height / 2,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height / 2,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, index) { 
          final movie = movies[index];
          movie.heroId ='swiper-${movie.id}'; 
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/loading.gif'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}