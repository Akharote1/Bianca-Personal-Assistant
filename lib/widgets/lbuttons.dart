
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';

class LButton extends StatelessWidget{
  final bool raised, white, disabled;
  final Widget? child;
  final String text;
  final VoidCallback? onPressed;

  LButton({
    this.raised = true,
    this.white = true,
    this.child,
    this.text = '',
    this.onPressed,
    this.disabled = false
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              getBackgroundColor()
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
              getTextColor()
          ),
          overlayColor: MaterialStateProperty.all<Color>(
              getTextColor().withOpacity(0.25)
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 32)
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64),
                side: raised ? BorderSide.none : BorderSide(
                    color: getTextColor(),
                    width: 2
                )
            ),
          ),

        ),
        onPressed: disabled ? null : (onPressed ?? () {}),
        child: child ?? Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(){
    if(raised) {
      if(white) {
        return Colors.white;
      }
      return AppColors.primary;
    }
    return Colors.transparent;
  }

  Color getTextColor(){
    if(raised) {
      if(white) {
        return AppColors.primary;
      }
      return Colors.white;
    }
    if(white){
      return Colors.white;
    }
    return AppColors.primary;
  }

}