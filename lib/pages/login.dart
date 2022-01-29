import 'package:bianca/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/progress_gauge.dart';

class LoginPage extends StatefulWidget{

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{
  late TextEditingController emailCont, passCont;
  bool disabled = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    emailCont = TextEditingController();
    passCont = TextEditingController();

    void onUpdate(){
      disabled = false;
      error = '';
      if(emailCont.value.text.trim().isEmpty ||
          passCont.value.text.trim().isEmpty){
        disabled = true;
      }
      else if(!RegExp('^((?:[a-zA-Z0-9]+[._])*[a-zA-Z0-9]+)@((?:[a-zA-Z-]{2,}.)+'
          '[a-zA-Z]{2,}\$)').hasMatch(emailCont.value.text)){
        disabled = true;
        error = 'Invalid email';
      }
      else if(!RegExp('^[a-zA-Z0-9*.\$%^&@#?~!/\\\\]+\$')
          .hasMatch(passCont.value.text)){
        disabled = true;
        error = 'Invalid password';
      }
      else if(passCont.value.text.length < 8){
        disabled = true;
        error = 'Password is too short';
      }
      setState(() {
        if(Config.debug){
          disabled = false;
          error = '';
        }
      });
    }

    emailCont.addListener(onUpdate);
    passCont.addListener(onUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CurveHeader(
            child: Container(
              width: double.infinity,
              height: 256,
              color: AppColors.primary,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 256,
                    child: Opacity(
                      child: Image.asset(
                        'assets/bg1.png',
                        fit: BoxFit.cover,
                      ),
                      opacity: 0.1,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 196,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 48),
                    child: SizedBox(
                      width: 180,
                      child: Image.asset(
                        'assets/logo.png'
                      ),
                    )
                  )
                ],
              )
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Column(
                  children: [
                    const SizedBox(height: 32,),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 32,),
                    LTextField(
                      title: 'Email',
                      hint: 'aditya.kharote@spit.ac.in',
                      controller: emailCont,
                    ),
                    const SizedBox(height: 16,),
                    LTextField(
                      title: 'Password',
                      hint: 'At least 8 characters',
                      obscureText: true,
                      controller: passCont,
                    ),
                    const SizedBox(height: 16,),
                    if(disabled && error != '')
                      Text(
                        error,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    const SizedBox(height: 32,),
                    SizedBox(
                      width: double.infinity,
                      child: LButton(
                        raised: true,
                        white: false,
                        text: 'LOGIN',
                        disabled: disabled,
                      ),
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: LButton(
                        raised: false,
                        white: false,
                        text: 'SIGN UP INSTEAD',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}