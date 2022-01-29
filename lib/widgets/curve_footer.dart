import 'package:bianca/colors.dart';
import 'package:flutter/cupertino.dart';

class CurveFooter extends StatelessWidget{
  final Widget child;

  const CurveFooter({ required this.child });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      painter: CurvePainter(),
    );
  }

}

class CurvePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 16)
      ..arcToPoint(
          const Offset(0, 16),
          radius: Radius.circular(size.width)
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}