import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {

  const ControlButton({Key? key, this.onPressed, this.icon}) : super(key: key);

  final Function? onPressed;
  final Icon ?icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0.5,
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.black38,
            elevation: 0,
            onPressed: () => onPressed!(),
            child: icon,
          ),
        ),
      ),);
  }
}
