import 'dart:async';
import 'dart:convert';

import 'package:bianca/colors.dart';
import 'package:bianca/providers/user.dart';
import 'package:bianca/widgets/back_button.dart' as bb;
import 'package:bianca/widgets/curve_footer.dart';
import 'package:bianca/widgets/mic_button.dart';
import 'package:bianca/widgets/popup_dialog.dart';
import 'package:bianca/widgets/pressable.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{

  Map<String, dynamic>? _weatherData = null;
  Map<String, dynamic>? _movieData = null;

  String currentText = '';
  bool micActive = false;

  FlutterTts flutterTts = FlutterTts();


  bool _chatMode = false;
  List<Map<String, dynamic>> chatData = [
    {
      'type': 'text',
      'text': 'Hello there! I am Bianca!',
      'incoming': true
    },
  ];

  List<Map<String, dynamic>> rows = [
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();
    fetchMoviesList();
    fetchTVList();
  }

  void fetchWeather() async {
    var url = Uri.parse('https://api.weatherapi.com/v1/current.json?key=c98719dc5e224431bc7201624222901&q=Mumbai&aqi=no');
    var response = await http.get(url);
    if(response.statusCode == 200){
      setState(() {
        _weatherData = jsonDecode(response.body);
      });
    }
  }

  void fetchMoviesList() async {
    var url = Uri.parse('http://api.themoviedb.org/3/discover/movie?api_key=631d5f2f42238791f06db43bf02cd4fb');
    var response = await http.get(url);
    if(response.statusCode == 200){
      var row = {
        'title': 'Movies for you',
        'items': [],
        'required_interest': 'movies'
      };
      List<Map<String, dynamic>> list = [];
      Map<String, dynamic> _movieData = jsonDecode(response.body);
      for(var item in _movieData['results']){
        list.add({
          'title': item['title'],
          'image': 'https://image.tmdb.org/t/p/w500'+item['backdrop_path'],
          'url': 'https://www.themoviedb.org/movie/'+item['id'].toString()
        });
        row['items'] = list;
      }
      setState(() {
        rows.add(row);
      });
    }
  }

  void fetchTVList() async {
    var url = Uri.parse('http://api.themoviedb.org/3/discover/tv?api_key=631d5f2f42238791f06db43bf02cd4fb');
    var response = await http.get(url);
    if(response.statusCode == 200){
      var row = {
        'title': 'Series for you',
        'items': [],
        'required_interest': 'shows'
      };
      List<Map<String, dynamic>> list = [];
      Map<String, dynamic> _movieData = jsonDecode(response.body);
      for(var item in _movieData['results']){
        list.add({
          'title': item['name'],
          'image': 'https://image.tmdb.org/t/p/w500'+item['backdrop_path'],
          'url': 'https://www.themoviedb.org/tv/'+item['id'].toString()
        });
        row['items'] = list;
      }
      setState(() {
        rows.add(row);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _){
              if(_chatMode) {
                return ChatPage(userProvider, micActive, currentText, chatData);
              }
              return _recommendations(userProvider);
            },
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
                    onTap: () {
                      Navigator.pushNamed(context, '/scanner');
                    },
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
                      onTap: () {
                        setState(() {
                          _chatMode = !_chatMode;
                        });
                      },
                      child: const Icon(
                        Icons.swap_horiz
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
        child: SizedBox(
          width: 96,
          height: 96,
          child: MicButton(
            onMicUpdate: (active, text){
              setState(() {
                micActive = active;
                currentText = text;
                _chatMode = true;
                if(micActive == false && currentText != ''){
                  String message = currentText;
                  setState(() {
                    chatData.insert(0, {
                      'type': 'text',
                      'text': currentText,
                      'incoming': false
                    });
                    currentText = '';
                  });
                  sendMessage(message);
                }
              });
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void sendMessage(String message) async{
    var url = Uri.parse('${UserProvider.BASE_URI}/chat?message='+
        Uri.encodeComponent(message));
    var response = await http.get(url);

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      if(result['success'] == true) {
        String intent = result['intent'];
        if(!intent.startsWith('action')){
          setState(() {
            String answer = result['answer'] ?? '?';
            answer = answer.replaceAll('{{name}}',
                provider.userData['full_name'].split(' ').first);
            chatData.insert(0, {
              'type': 'text',
              'text': answer,
              'incoming': true
            });
            flutterTts.speak(answer);
          });
        } else {
          if(intent == 'actions.openurl'){
            if(result['entities'].length == 0) {
              setState(() {
                String answer = 'You have not specified any URL to open.';
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
              });
            } else {
              setState(() {
                String mUrl = result['entities'][0]['value'];
                if(!mUrl.startsWith('http')){
                  mUrl = 'http://$mUrl';
                }
                String answer = 'Opening '+mUrl;
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
                Timer(const Duration(milliseconds: 2000), (){
                  launch(mUrl);
                });
              });
            }
          }

          if(intent == 'actions.call'){
            if(result['entities'].length == 0) {
              setState(() {
                String answer = 'You have not specified any number to call.';
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
              });
            } else {
              setState(() {
                String mNo = '';
                for(var no in result['entities']){
                  if(no['type']=='phonenumber'){
                    mNo = no['value'];
                  }
                }
                mNo = mNo.replaceAll(' ', '');
                String answer = 'Calling '+mNo;
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
                Timer(const Duration(milliseconds: 2000), (){
                  launch("tel://"+mNo);
                });
              });
            }
          }

          if(intent == 'actions.sms'){
            if(result['entities'].length == 0) {
              setState(() {
                String answer = 'You have not specified any number to sms.';
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
              });
            } else {
              setState(() {
                String mNo = '';
                for(var no in result['entities']){
                  if(no['type']=='phonenumber'){
                    mNo = no['value'];
                  }
                }
                mNo = mNo.replaceAll(' ', '');
                String answer = 'Messaging '+mNo;
                chatData.insert(0, {
                  'type': 'text',
                  'text': answer,
                  'incoming': true
                });
                flutterTts.speak(answer);
                Timer(const Duration(milliseconds: 2000), (){
                  launch("sms://"+mNo);
                });
              });
            }
          }

          if(intent.startsWith('actions.music')) {
            setState(() {
              String answer = 'Playing music on Spotify';
              chatData.insert(0, {
                'type': 'text',
                'text': answer,
                'incoming': true
              });
              flutterTts.speak(answer);
              Timer(const Duration(milliseconds: 2000), () async {
                await LaunchApp.openApp(
                  androidPackageName: 'com.spotify.music',
                );
              });
            });
          }

        }
      }
    }
  }

  Widget _recommendations(UserProvider userProvider){
    if(micActive){
      return Text(
        currentText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
      );
    }
    return Column(
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
                    '${userProvider.userData['full_name'].toString().split(' ').first}!',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                    ),
                  ),
                ],
              ),
            ),
            Pressable(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('access_token');
                userProvider.accessToken = null;
                while(Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushNamed(context, '/splash');
              },
              child: ClipOval(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: userProvider.userData['profile_picture'] != null ?
                  Image.network(
                    userProvider.userData['profile_picture'],
                    fit: BoxFit.cover,
                  ) :
                  Image.asset(
                    'assets/interests/anime.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
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
                _createWeather(userProvider),
                ..._createRecList(),
              ],
            ),
          ),
        )
      ],
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
                return Pressable(
                  onPressed: (){
                    launch(row['items'][index % row['items'].length]['url']);
                  },
                  child: Container(
                    width: 96,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 128,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              row['items'][index % row['items'].length]['image'],
                              fit: BoxFit.cover,
                            ),
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
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                );
              }
            )
          )
        ],
      );
    }).toList();
  }

  Widget _createWeather(UserProvider userProvider) {
    if(_weatherData == null) {
      return Container(
        width: double.infinity,
        height: 192,
        child: const CircularProgressIndicator(),
        alignment: Alignment.center,
      );
    }
    return Container(
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
                  child: Lottie.asset(_getWeatherAnimation())
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_weatherData!['current']['temp_c']} °C',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      _weatherData!['current']['condition']['text'],
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
            _getWeatherTip(),
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  String _getWeatherAnimation(){
    String text = _weatherData!['current']['condition']['text'].toString().toLowerCase();
    if(text.contains('sun')) return 'assets/animations/sunny.json';
    if(text.contains('snow')) return 'assets/animations/snowy.json';
    if(text.contains('rain')) return 'assets/animations/rainy.json';
    if(text.contains('cloud') || text.contains('overcast')) return 'assets/animations/cloudy.json';
    return 'assets/animations/sunny.json';
  }

  String _getWeatherTip(){
    String text = _weatherData!['current']['condition']['text'].toString().toLowerCase();
    if(text.contains('sun')) return 'Wear light clothing and stay hydrated.';
    if(text.contains('snow')) return 'It\'s cold. Wear a jacket or sweater and stay safe';
    if(text.contains('ice')) return 'It\'s freezing. Stay safe';
    if(text.contains('rain')) return 'It\'s rainy. Carry an umbrella or raincoat';
    if(text.contains('cloud') || text.contains('overcast')) {
      return 'It\'s cloudy outside. Carry an umbrella ☔';
    }
    return 'The weather seems good today. Have a great day :D';
  }

}

class ChatPage extends StatefulWidget {
  UserProvider userProvider;
  String currentText;
  bool micActive;
  List<Map<String, dynamic>> chatData;

  ChatPage(this.userProvider, this.micActive, this.currentText, this.chatData,
      {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.chatData.length,
            reverse: true,
            itemBuilder: (context, i){
              return MessageBubble(widget.chatData[i]);
            }
          )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(
            widget.currentText,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> msg;

  const MessageBubble(this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
        child: Row(
          mainAxisAlignment: msg['incoming'] ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            SizedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: getDecoration(),
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(
                  msg['text'],
                  style: TextStyle(
                      color: msg['incoming'] ? Colors.black.withOpacity(0.8) : Colors.white
                  ),
                ),
              ),
              width: 256,
            )
          ],
        )
    );
  }
  
  BoxDecoration getDecoration(){
    if(msg['incoming']){
      return const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        color: Colors.white
      );
    } else {
      return const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4),
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        color: AppColors.primary
      );
    }
  }

}