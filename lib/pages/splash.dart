import 'package:bianca/providers/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/text_switcher.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }

}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    checkLoginState();
  }

  void checkLoginState() async{
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    String? token = await provider.loadAccessToken();
    if(token == null) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Map<String, dynamic> result = await provider.verifyToken();
      if(result['success'] == true){
        await provider.reloadUserData();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

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
                  Expanded(
                    child: Container(
                      width: 128,
                      margin: const EdgeInsets.only(bottom: 96),
                      child: Lottie.asset('assets/animations/loading2.json'),
                    )
                  ),
                ],
              ),
            )
          ],
        )
    );
  }

}