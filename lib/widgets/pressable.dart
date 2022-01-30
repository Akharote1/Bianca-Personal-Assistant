import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pressable extends StatefulWidget {
  VoidCallback? onPressed;
  Widget child;

  Pressable({Key? key, this.onPressed, required this.child}) : super(key: key);

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.9 : 1,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() {
          _pressed = true;
        }),
        onTapUp: (_) => setState(() {
          _pressed = false;
        }),
        onTapCancel: () => setState(() {
          _pressed = false;
        }),
        onTap: (){
          if(widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: widget.child,
      ),
    );
  }
}
