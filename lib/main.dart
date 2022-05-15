import 'package:first_game/StartPage.dart';
import 'package:flutter/material.dart';
import 'Game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      home: StartPage(),
    );
  }
}
