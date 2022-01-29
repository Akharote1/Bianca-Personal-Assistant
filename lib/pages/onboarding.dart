import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/text_switcher.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnboardingPageState();
  }

}

class OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Opacity(
                child: Image.asset(
                  'assets/bg1.png',
                  fit: BoxFit.cover,
                ),
                opacity: 0.05,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 196,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 32),
                      child: SizedBox(
                        width: 180,
                        child: Image.asset(
                          'assets/logo.png'
                        ),
                      )
                  ),
                  const Expanded(
                    child: TextSwitcher(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: LButton(
                      text: 'LOGIN',
                      onPressed: (){
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: LButton(
                      text: 'SIGN UP',
                      raised: false,
                      onPressed: (){
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                  const SizedBox(height: 32,)
                ],
              ),
            )
          ],
        )
    );
  }

}