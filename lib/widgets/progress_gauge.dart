import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'dart:math' as math;

class ProgressGauge extends StatefulWidget{
  const ProgressGauge({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProgressGaugeState();
  }
}

class ProgressGaugeState extends State<ProgressGauge>
    with TickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _tween = Tween(begin: 0, end: (948 / 2400));

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ProgressGaugePainter(animation.value),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "948",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 42,
                ),
              ),
              const Text(
                "Calories",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Goal: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "2400",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80,)
            ],
          ),
        )
      ]
    );
  }

}

class ProgressGaugePainter extends CustomPainter{
  double progress;

  ProgressGaugePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    var lowerPaint = Paint()
      ..color = const Color(0x330B6BFD)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    var upperPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double start = - (math.pi + 0.3);
    double sweep = (math.pi + 0.6);

    canvas.drawArc(
        Rect.fromLTRB(0, 0, size.width, size.height),
        start,
        sweep,
        false,
        lowerPaint
    );

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      start,
      sweep * progress,
      false,
      upperPaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}