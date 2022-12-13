import 'package:flutter/material.dart';
import 'package:movies_flutter_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Movies Play'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CardSwiper(),
            MovieSlider()
          ],
        ),
      ),
    );
  }
}