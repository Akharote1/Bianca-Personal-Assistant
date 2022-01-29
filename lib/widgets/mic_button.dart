import 'package:bianca/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MicButton extends StatefulWidget {
  const MicButton({Key? key}) : super(key: key);

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool _pressed = false;


  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.8 : 1,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () {  },
        onTapDown: (_) => setState(() {
          _pressed = true;
        }),
        onTapUp: (_) => setState(() {
          _pressed = false;
        }),
        onTapCancel: () => setState(() {
          _pressed = false;
        }),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(32)
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(
            FontAwesomeIcons.microphone,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
