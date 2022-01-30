import 'dart:io';

import 'package:bianca/config.dart';
import 'package:bianca/widgets/pressable.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';
import 'package:bianca/widgets/curve_header.dart';
import 'package:bianca/widgets/lbuttons.dart';
import 'package:bianca/widgets/ltextfield.dart';
import 'package:bianca/widgets/back_button.dart' as bb;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool imageTaken = false;
  String imagePath = '';
  String? deduction = null;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    setState(() {
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: !imageTaken ? CameraPreview(_controller,) :
                        Image.file(File(imagePath))
                  );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 24.0),
                        child: bb.BackButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: imageTaken ? _answerView() : _cameraControls()
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void guessFromImage() async {
    final File file = File(imagePath);
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(file);
    final ImageLabeler labeler = GoogleVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);
    if(labels.isEmpty) {
      deduction = null;
    } else {
      deduction = labels.first.text!;
    }
  }

  Widget _answerView(){
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  'Guessing',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 16,),
                if(deduction != null)
                  Text(
                    deduction!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                if(deduction == null)
                  const Text(
                    'Could not find a match',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                const SizedBox(height: 16,),
                if(deduction != null)
                  LButton(
                    text: 'View more',
                    raised: false,
                    white: false,
                    onPressed: () {

                    },
                  )
              ],
            ),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                imageTaken = false;
                imagePath = '';
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )
          )
        ],
      )
    );
  }

  Widget _cameraControls(){
    return Container(
      width: double.infinity,
      height: 192,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5)
              ]
          )
      ),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Pressable(
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
            onPressed: () async{
              XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
              if(file != null) {
                setState(() {
                  imagePath = file.path;
                  imageTaken = true;
                });
              }
            },
          ),
          Pressable(
            onPressed: () async {
              try {
                final image = await _controller.takePicture();
                imageTaken = true;
                imagePath = image.path;
                setState(() {
                  guessFromImage();
                });
              }catch(e) {
                print(e);
              }
            },
            child: Container(            //Camera Button
              height: 84,
              width: 84,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
                color: Colors.white,
              ),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all()
                ),
              ),
            ),
          ),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.0),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}




