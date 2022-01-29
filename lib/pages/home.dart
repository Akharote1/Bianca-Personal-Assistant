import 'package:bianca/colors.dart';
import 'package:bianca/widgets/back_button.dart' as bb;
import 'package:bianca/widgets/curve_footer.dart';
import 'package:bianca/widgets/mic_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{

  List<Map<String, dynamic>> rows = [
    {
      'title': 'Movies for you',
      'items': [
        {
          'title': 'Avengers: Endgame',
          'image':  'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/d1pklzbuyaab0la-1552597012.jpg'
        }
      ]
    },
    {
      'title': 'Books for you',
      'items': [
        {
          'title': 'Avengers: Endgame',
          'image':  'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/d1pklzbuyaab0la-1552597012.jpg'
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 32,),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: Lottie.asset('assets/animations/cloudy.json')
                                ),
                                const SizedBox(width: 16,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '10 °C',
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.black.withOpacity(0.75),
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        'Sunny',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black.withOpacity(0.75),
                                            fontWeight: FontWeight.w600
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16,),
                            Text(
                              'Wear light clothing',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w500
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      ..._createRecList(),

                    ],
                  ),
                ),
              )
            ],
          )
        ),
      ),
      bottomNavigationBar: CurveFooter(
        child: SizedBox(
          width: double.infinity,
          height: 128,
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(top: 36, left: 32),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      FontAwesomeIcons.camera
                    )
                ),
              ),
              Expanded(
                  child: Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(top: 36, right: 32),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        FontAwesomeIcons.keyboard
                      )
                    ),
                  )
              )
            ],
          )
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

  List<Widget> _createRecList(){
    return rows.map((row){
      return Column(
        children: [
          const SizedBox(height: 32,),
          Text(
            row['title'] ?? '',
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16
            ),
          ),
          const SizedBox(height: 16,),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: 96,
                  height: 144,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          row['items'][index % row['items'].length]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        row['items'][index % row['items'].length]['title'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              }
            )
          )
        ],
      );
    }).toList();
  }

}
