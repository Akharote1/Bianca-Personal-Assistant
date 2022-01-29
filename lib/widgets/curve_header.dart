import 'package:flutter/cupertino.dart';

class CurveHeader extends StatelessWidget{
  final Widget child;

  const CurveHeader({ required this.child });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: child,
      clipper: CurveClipper(),
    );
  }

}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 64)
      ..arcToPoint(
        Offset(0, size.height - 64),
        radius: Radius.circular(size.width)
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}