import 'package:first_game/ControlButton.dart';
import 'package:first_game/Direction.dart';
import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction dir)? onTapped;

  const ControlPanel({Key? key, this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Row(
          children: [
            Expanded(
                child: Row(children: [
              Expanded(child: Container()),
              ControlButton(
                  onPressed: () {
                    onTapped!(Direction.left);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left_rounded))
            ])),
            Expanded(
                child: Column(
              children: [
                ControlButton(
                    onPressed: () => onTapped!(Direction.up),
                    icon: const Icon(Icons.keyboard_arrow_up_rounded)),
                const SizedBox(height: 70),
                ControlButton(
                    onPressed: () => onTapped!(Direction.down),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded)),
              ],
            )),
            Expanded(
                child: Row(children: [
                  ControlButton(
                    onPressed: () => onTapped!(Direction.right),
                    icon: const Icon(Icons.keyboard_arrow_right_rounded)),
                  Expanded(child: Container()),
            ])),
          ],
        ),
        left: 0.0,
        right: 0.0,
        bottom: 20.0);
  }
}
