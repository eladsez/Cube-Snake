import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int posX, posY, size;
  final Color color;
  final bool isAnimated;

  const Piece({Key? key,
    required this.color,
    this.size = 0,
    required this.posX,
    required this.posY,
    this.isAnimated = false})
      : super(key: key);

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void dispose() { // This function is because some kind of exception see here: https://stackoverflow.com/questions/58802223/flutter-ticker-must-be-disposed-before-calling-super-dispose#:~:text=Add%20a%20comment-,1,-Answer
    animationController?.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.25,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 1500));
    animationController?.addStatusListener((status) {
      if (animationController!.isCompleted) {
        animationController?.reset();
      }
      else if (animationController!.isDismissed) {
        animationController?.forward();
      }
    });
    animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.posY.toDouble(),
      left: widget.posX.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated?animationController!.value : 1,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 2.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
