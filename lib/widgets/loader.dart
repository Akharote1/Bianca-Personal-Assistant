import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../colors.dart';

class LoaderDialog extends StatelessWidget{
  String text;
  bool cancellable = false;
  Function? onCancel;

  LoaderDialog({
    Key? key,
    required this.text,
    required this.cancellable,
    required this.onCancel,
  }) : super(key: key);

  static show(BuildContext context, {
    String message="Loading...",
    bool cancellable=false,
    Function? onCancel,
  }){
    showGeneralDialog(
        context: context,
        pageBuilder: (context, a1, a2){
          return const Text("");
        },
        transitionBuilder: (context, a1, a2, widget){
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4*a1.value, sigmaY: 4*a1.value),
              child: Transform.scale(
                  scale: a1.value*0.75+0.25,
                  child: Opacity(
                      opacity: a1.value,
                      child: Material(
                        color: Colors.transparent,
                        child: LoaderDialog(
                            text: message,
                            cancellable: cancellable,
                            onCancel: onCancel
                        ),
                      )
                  )
              )
          );
        },
        barrierDismissible: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: Container(
                width: 192,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      child: LottieBuilder.asset('assets/animations/loading1.json'),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      text,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        color: AppColors.primary
                      ),
                      textAlign: TextAlign.center,

                    ),
                    const SizedBox(height: 16),
                    if(cancellable) SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          onCancel?.call();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 8)
                          ),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )
        )
    );
  }

}
