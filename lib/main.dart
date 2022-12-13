import 'package:flutter/material.dart';
import 'package:movies_flutter_app/screens/screens.dart';
import 'package:movies_flutter_app/themes/theme_movies.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: 'home',
      routes: {
        'home':(  _) => const HomeScreen(),
        'details':(_) => const DetailsScreen()
      },
      theme: MoviesTheme.moviesTheme,
    );
  }
}