import 'package:bianca/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/back_button.dart' as bb;
import 'package:bianca/widgets/progress_gauge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          width: double.infinity,
          //alignment: Alignment.topLeft,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 24.0),
                      child: bb.BackButton(),
                  ),
                ],
              ),
              SizedBox(
                height: 512.0,
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.images,
                        size: 18,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(            //Camera Button
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}




