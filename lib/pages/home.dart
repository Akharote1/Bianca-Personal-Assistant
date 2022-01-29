import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_footer.dart';
import 'package:bianca/widgets/mic_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Hello ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              fontSize: 20
                          ),
                        ),Text(
                          'Aditya!',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipOval(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.network('https://instagram.fbom3-1.fna.fbcdn.net/v/t51.2885-19/272224634_610226763386721_7606637231882190558_n.jpg?stp=dst-jpg_s320x320&cb=9ad74b5e-7e291d1f&_nc_ht=instagram.fbom3-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=e4xB38uVKTAAX-qukA3&edm=ABfd0MgBAAAA&ccb=7-4&oh=00_AT_N5NMH0rPBhcyNUh9FctMoRUKvBgFjCLGSvLug22VYRQ&oe=61FB8D08&_nc_sid=7bff83'),
                    ),
                  )
                ],
              ),
            ],
          )
        ),
      ),
      bottomNavigationBar: const CurveFooter(
        child: SizedBox(
          width: double.infinity,
          height: 128,
        )
      ),
      floatingActionButton: Container(
        width: 96,
        height: 224,
        padding: const EdgeInsets.only(top: 128),
        child: const SizedBox(
          width: 96,
          height: 96,
          child: MicButton(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}