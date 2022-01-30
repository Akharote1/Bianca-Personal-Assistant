import 'package:bianca/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;

class MicButton extends StatefulWidget {
  Function onMicUpdate;

  MicButton({Key? key, required this.onMicUpdate}) : super(key: key);

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool _pressed = false;
  bool isMicActive = false;
  bool _speechEnabled = false;
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      onDevice: true
    );
    setState(() {
      isMicActive = true;
      widget.onMicUpdate(isMicActive, _lastWords);
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isMicActive = false;
      widget.onMicUpdate(isMicActive, _lastWords);
      _lastWords = '';
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      widget.onMicUpdate(isMicActive, _lastWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.8 : 1,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMicActive = !isMicActive;
            if(isMicActive) {
              _startListening();
            } else {
              _stopListening();
            }
          });
        },
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
          child: getChild(),
        ),
      ),
    );
  }

  Widget getChild(){
    if(isMicActive) {
      return MicWaveform();
    }
    return const Icon(
      FontAwesomeIcons.microphone,
      color: Colors.black,
    );
  }
}

class MicWaveform extends StatefulWidget {
  const MicWaveform({Key? key}) : super(key: key);

  @override
  _MicWaveformState createState() => _MicWaveformState();
}

class _MicWaveformState extends State<MicWaveform> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation a1, a2, a3, a4;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(),
    );
  }
}


class WaveformPainter extends CustomPainter{
  List<double> heights = [0.2, 0.8, 0.5, 0.6];

  WaveformPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    double mWidth = 4;
    int maxHeight = 32;
    double startLeft = (size.width / 2 - (mWidth * 4));
    for(int i = 0; i < 4; i++) {
      double height = heights[i] * maxHeight;
      if(height < mWidth) {
        height = mWidth;
      }
      canvas.drawRRect(RRect.fromLTRBR(
          startLeft + i * 2 * mWidth,
          size.height / 2 - height / 2,
          startLeft + i * 2 * mWidth + mWidth ,
          size.height / 2 + height / 2,
          Radius.circular(mWidth)), paint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
}
