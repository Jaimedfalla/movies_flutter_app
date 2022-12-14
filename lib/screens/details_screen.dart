import 'package:flutter/material.dart';
import 'package:movies_flutter_app/widgets/widgets.dart';

import '../models/movie.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    /* Para asignar a la variable, el valor de los argumentos
    * que se envía en el navigator.from y que corresponde al parámetro movie-instance*/
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          /*Dentro de un SliverList solo se pueden colocar widgets que hereden de Sliver.
          * SliverChildDelegate se utiliza para poner dentro de él Widget estáticos*/
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie: movie),
              _Overview(resume: movie.overview),
              _Overview(resume: movie.overview),
              _Overview(resume: movie.overview),
              const CastingCards()
            ])
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar({
    super.key,
    required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          color: Colors.black12,
          child: Text(movie.title,
            style: const TextStyle(fontSize: 16),)
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;

  const _PosterAndTitle({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/loading.gif'),
              image: NetworkImage(movie.fullPosterImg),
              height: 150,
            ),
          ),

          const SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,style: textTheme.headline5,overflow: TextOverflow.ellipsis,maxLines: 2),
                Text(movie.originalTitle,style: textTheme.subtitle1,overflow: TextOverflow.ellipsis,maxLines: 2),
                
                Row(
                  children:[
                    const Icon(
                      Icons.star_outline,
                      size: 15,
                      color: Colors.grey),
                    const SizedBox(width:5),
                    Text('${movie.voteAverage}',style: textTheme.caption)
                  ]
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final String resume;

  const _Overview({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        resume,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}