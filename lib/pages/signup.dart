import 'package:bianca/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/progress_gauge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget{

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        itemBuilder: (context, i) {
          return getPage(i) ?? Container();
        },
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
      )
    );
  }

  Widget? getPage(int currentPage){
    if(currentPage == 0) {
      return SignUpPage1(this);
    }
    if(currentPage == 1) {
      return SignUpPage2(this);
    }
    if(currentPage == 2) {
      return SignUpPage3(this);
    }
    if(currentPage == 3) {
      return SignUpPage4(this);
    }
  }
}

class SignUpPage1 extends StatefulWidget{
  SignUpPageState root;

  SignUpPage1(this.root);

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  late TextEditingController emailCont, passCont, cpassCont;
  bool disabled = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    emailCont = TextEditingController();
    passCont = TextEditingController();
    cpassCont = TextEditingController();

    void onUpdate(){
      disabled = false;
      error = '';
      if(emailCont.value.text.trim().isEmpty ||
          passCont.value.text.trim().isEmpty ||
          cpassCont.value.text.trim().isEmpty){
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
      else if(passCont.value.text != cpassCont.value.text){
        disabled = true;
        error = 'Passwords do not match';
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
    cpassCont.addListener(onUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      'SIGN UP',
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
                    LTextField(
                      title: 'Confirm Password',
                      hint: 'At least 8 characters',
                      obscureText: true,
                      controller: cpassCont,
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
                        text: 'SIGN UP',
                        disabled: disabled,
                        onPressed: (){
                          widget.root.controller.animateToPage(1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeIn);
                        },
                      ),
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: LButton(
                        raised: false,
                        white: false,
                        text: 'LOGIN INSTEAD',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]
    );
  }
}

class SignUpPage2 extends StatefulWidget {

  SignUpPageState root;

  SignUpPage2(this.root);

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  late TextEditingController otpCont;
  bool disabled = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    otpCont = TextEditingController();

    void onUpdate(){
      disabled = false;
      error = '';

      if(otpCont.value.text.trim().length != 4){
        disabled = true;
      }

      setState(() {
        if(Config.debug){
          disabled = false;
          error = '';
        }
      });
    }

    otpCont.addListener(onUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      'VERIFY EMAIL',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 32,),
                    LTextField(
                      title: 'OTP',
                      hint: '4 Digit OTP',
                      controller: otpCont,
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
                        text: 'VERIFY',
                        disabled: disabled,
                        onPressed: (){
                          widget.root.controller.animateToPage(2,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn);
                        },
                      ),
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: LButton(
                        raised: false,
                        white: false,
                        text: 'RESEND OTP',
                        onPressed: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]
    );
  }
}

class SignUpPage3 extends StatefulWidget {

  SignUpPageState root;

  SignUpPage3(this.root);

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  bool disabled = true;
  String error = '';

  @override
  void initState() {
    super.initState();

    void onUpdate(){
      disabled = false;
      error = '';

      setState(() {
        if(Config.debug){
          disabled = false;
          error = '';
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: CurveHeader(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.primary,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
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
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 108),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Your',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    ' Profile',
                                    style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Lottie.network('https://assets5.lottiefiles.com/packages/lf20_9eLZ98.json'),
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Column(
              children: [
                const SizedBox(height: 32,),
                LTextField(
                    title: 'Full Name',
                    hint: 'Aditya Kharote'
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: LTextField(
                          title: 'Age',
                          hint: '18'
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: LTextField(
                          title: 'Gender',
                          hint: '----'
                      ),
                    )
                  ],
                ),
                if(disabled && error != '')
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
                FloatingActionButton(
                  onPressed: (){
                    widget.root.setState(() {
                      widget.root.controller.animateToPage(3,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeIn);
                    });
                  },
                  child: const Padding(
                    child: Icon(
                      FontAwesomeIcons.arrowRight,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  elevation: 0,
                  hoverElevation: 1,
                  focusElevation: 1,
                ),
                const SizedBox(height: 32,),
              ],
            ),
          ),
        ]
    );
  }
}


class SignUpPage4 extends StatefulWidget {

  SignUpPageState root;

  SignUpPage4(this.root);

  @override
  State<SignUpPage4> createState() => _SignUpPage4State();
}

class _SignUpPage4State extends State<SignUpPage4> {

  static List<Map<String, dynamic>> interestList = [
    {
      'name': 'Music',
      'image': 'music-img.jpg',
      'id': 'music',
      'checked': false
    },
    {
      'name': 'Movies',
      'image': 'movies-img.jpg',
      'id': 'movies',
      'checked': false
    },
    {
      'name': 'Shows',
      'image': 'shows-img.jpg',
      'id': 'shows',
      'checked': false
    },
    {
      'name': 'Fitness',
      'image': 'fitness-img.jpg',
      'id': 'fitness',
      'checked': false
    },
    {
      'name': 'Anime',
      'image': 'anime-img.jpg',
      'id': 'anime',
      'checked': false
    },
    {
      'name': 'Programming',
      'image': 'programming-img.jpg',
      'id': 'programming',
      'checked': false
    },
    {
      'name': 'Travelling',
      'image': 'travelling-img.jpg',
      'id': 'travelling',
      'checked': false
    },
    {
      'name': 'Architecture',
      'image': 'architecture-img.jpg',
      'id': 'architecture',
      'checked': false
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
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
                        margin: const EdgeInsets.only(top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Choose',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Text(
                              ' Interests',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600
                              ),
                            )
                          ],
                        )
                    )
                  ],
                )
            ),
          ),
          const SizedBox(height: 24,),
          const Text(
            'What do you like?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    childAspectRatio: 1.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: interestList.map((item){
                      return _createCard(item);
                    }).toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 32),
                  child: FloatingActionButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Padding(
                      child: Icon(
                        FontAwesomeIcons.arrowRight,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8),
                    ),
                    elevation: 0,
                    hoverElevation: 1,
                    focusElevation: 1,
                  ),
                )
              ],
            )
          )
        ]
    );
  }

  Widget _createCard(Map<String, dynamic> item){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          item['checked'] = !item['checked'];
        });
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/interests/${item['image']}',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Text(
              item['name'],
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          if(item['checked'] == true)
            Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.topRight,
                child: const Icon(
                  FontAwesomeIcons.check,
                  size: 16,
                )
            ),
        ],
      )
    );
  }
}
