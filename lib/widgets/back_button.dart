import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackButton extends StatefulWidget {
  VoidCallback? onPressed;

  BackButton({Key? key}) : super(key: key);

  @override
  State<BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.8 : 1,
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
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.black.withOpacity(0.5)
          ),
          child: const Icon(
            FontAwesomeIcons.chevronLeft,
            size: 18,
          ),
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
