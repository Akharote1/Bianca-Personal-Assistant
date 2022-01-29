import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';

class TextSwitcher extends StatefulWidget {
  const TextSwitcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextSwitcherState();
  }

}

class TextSwitcherState extends State<TextSwitcher> {
  final PageController _controller = PageController();
  late final Timer _timer;

  static const List<List<String>> _strings = [
    ['Find', 'Music'],
    ['Movie', 'Recommendations'],
    ['Track your', 'Schedule'],
    ['Explore', 'Interests'],
    ['Automate', 'Tasks'],
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      Duration duration = const Duration(milliseconds: 500);
      Curve curve = Curves.easeOut;
      _controller.nextPage(duration: duration, curve: curve);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
          stops: [0.0, 0.25, 0.75 , 1.0], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: SizedBox(
          width: double.infinity,
          height: 256,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index){
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _strings[index % _strings.length][0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(

                          fontSize: 48,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      _strings[index % _strings.length][1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 32,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ]
              );
            },
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

}