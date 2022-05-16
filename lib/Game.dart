import 'dart:async';
import 'package:first_game/ControlPanel.dart';
import 'package:first_game/Direction.dart';
import 'package:first_game/Piece.dart';
import 'package:first_game/Storage.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 25;
  int snakeLen = 5;
  List<Offset> positions = [];
  Offset? foodPos;
  Piece? food;
  Direction direction = Direction.up;
  Timer? timer;
  double speed = 1.0;
  int score = 0;
  int bestScore = 0;

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      // the ! before is a null safety check
      timer
          ?.cancel(); // the ? checking its because the timer can be null, stupid i know
    }
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  void restart() {
    score = 0;
    positions = [];
    snakeLen = 5;
    speed = 1;
    bestScore = Storage.getBestScore() ?? 0;
    changeSpeed();
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  Offset getRandPosition() {
    Random rand = Random();
    int posX = rand.nextInt(upperBoundX) + lowerBoundX;
    int posY = rand.nextInt(upperBoundY) + lowerBoundY;
    Offset position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  /// Function for rounding a number to the closest ten.
  int getNearestTens(int num) {
    int output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Widget getControl() {
    return ControlPanel(onTapped: (Direction newDir) {
      direction = newDir;
    });
  }

  Widget getScore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Score : " + score.toString(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontFamily: 'BebasNeue'),
        ),
        Text(
          "Best score : " + bestScore.toString(),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontFamily: 'BebasNeue'),
        ),
      ],
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    for (int i = 0; i < positions.length; ++i) {
      pieces.add(Piece(
          color: i.isEven ? Colors.red : Colors.brown,
          size: step,
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt()));
    }

    return pieces;
  }

  Opacity getRestartButton() {
    return Opacity(
        opacity: 0.5,
        child: SizedBox(
            width: 40,
            height: 40,
            child: FittedBox(
                child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.black38,
              onPressed: () {
                restart();
              },
              child: const Icon(Icons.refresh),
            ))));
  }

  Offset getNextPos(Offset prevPos) {
    late Offset newPos;
    if (direction == Direction.up) {
      newPos = Offset(prevPos.dx, prevPos.dy - step);
    }
    if (direction == Direction.down) {
      newPos = Offset(prevPos.dx, prevPos.dy + step);
    }
    if (direction == Direction.left) {
      newPos = Offset(prevPos.dx - step, prevPos.dy);
    }
    if (direction == Direction.right) {
      newPos = Offset(prevPos.dx + step, prevPos.dy);
    }
    return newPos;
  }

  bool detectCollision() {
    if (positions[0].dx > upperBoundX ||
        positions[0].dy > upperBoundY ||
        positions[0].dx < lowerBoundX ||
        positions[0].dy < lowerBoundY) {
      return true;
    }
    for (int i = 1; i < positions.length; ++i) {
      if (positions[0].dx == positions[i].dx &&
          positions[0].dy == positions[i].dy) {
        return true;
      }
    }
    return false;
  }

  void showGameOver() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 3.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text("Game Over",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'BebasNeue',
                    fontSize: 30)),
            content: Text("your score : " + score.toString(),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'BebasNeue')),
            actions: [
              TextButton(
                  onPressed: () async {
                    int? currBest = await Storage.getBestScore() ?? -1;
                    if (score > currBest) {
                      await Storage.updateBestScore(score);
                    }
                    Navigator.of(context).pop();
                    restart();
                  },
                  child: const Text("Restart",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'BebasNeue',
                          fontSize: 24)))
            ],
          );
        });
  }

  void draw() async {
    if (positions.isEmpty) {
      // positions.add(getRandPosition());
      positions.add(Offset(getNearestTens(upperBoundX ~/ 2).toDouble(),
          getNearestTens(upperBoundY ~/ 2).toDouble()));
    }
    // adding the new positions
    while (snakeLen > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    // updating the positions
    for (int i = positions.length - 1; i > 0; --i) {
      positions[i] = positions[i - 1];
    }

    positions[0] = getNextPos(positions[0]);

    if (detectCollision()) {
      if (timer != null && timer!.isActive) {
        timer?.cancel();
      }
      await Future.delayed(
          const Duration(milliseconds: 200), () => showGameOver());
    }
  }

  void drawFood() {
    foodPos ??= getRandPosition(); // if food == null so to the rand func
    food = Piece(
        color: Colors.green,
        posX: foodPos!.dx.toInt(),
        posY: foodPos!.dy.toInt(),
        size: step,
        isAnimated: true);

    if (foodPos == positions[0]) {
      foodPos = getRandPosition();
      ++snakeLen;
      speed += 0.05;
      score += 5;
      if (score > bestScore) {
        bestScore = score;
      }
      changeSpeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundX = 0;
    lowerBoundY = 0;
    upperBoundX = screenWidth.toInt();
    upperBoundY = screenHeight.toInt() - step ~/ 2;
    SystemChrome.setEnabledSystemUIOverlays([]); // full screen

    return GestureDetector(
      // responsible for the sliding detection
      onVerticalDragUpdate: (details) {
        // vertical sliding
        if (details.delta.direction > 0) {
          direction = Direction.down;
        } else {
          direction = Direction.up;
        }
      },
      onHorizontalDragUpdate: (details) {
        // horizontal sliding
        if (details.delta.direction > 0) {
          direction = Direction.left;
        } else {
          direction = Direction.right;
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.amber,
          child: Stack(
            children: [
              Positioned(top: 30, left: 15, child: getScore()),
              Positioned(top: 30, right: 15, child: getRestartButton()),
              Stack(
                children: getPieces(),
              ),
              // getControl(),
              food!
            ],
          ),
        ),
      ),
    );
  }
}
