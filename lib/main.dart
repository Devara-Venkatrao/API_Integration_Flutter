import 'package:flutter/material.dart';
import 'movie_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieDetail(),
      debugShowCheckedModeBanner: false,
    );
  }
}