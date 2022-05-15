import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:first_game/Game.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late double screenHeight;
  late double screenWidth;

  Widget jumpingText() {
    return Center(
        child: DefaultTextStyle(
      style: const TextStyle(
          color: Colors.red,
          fontSize: 90,
          fontFamily: 'BebasNeue',
          fontWeight: FontWeight.bold),
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          WavyAnimatedText('CUBE SNAKE'),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GamePage()));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.amber,
        width: screenWidth,
        height: screenHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              jumpingText(),
              const SizedBox(height: 200),
              TextButton(
                  child: const Text('press to start',
                      style: TextStyle(fontSize: 25, color: Colors.black26)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GamePage()));
                  })
            ]));
  }
}
