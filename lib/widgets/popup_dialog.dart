import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../colors.dart';

class PopupDialog extends StatelessWidget{
  String title;
  String message;
  List<PopupAction> actions;
  bool isCancellable;

  PopupDialog({
    Key? key,
    required this.title,
    required this.message,
    this.isCancellable = false,
    this.actions=const [],
  }) : super(key: key);

  static show(BuildContext context, {
    String title="",
    String message="",
    List<PopupAction> actions = const [],
    bool isCancellable = false,
  }){
    showGeneralDialog(
        context: context,
        pageBuilder: (context, a1, a2){
          return const Text("");
        },
        transitionBuilder: (context, a1, a2, widget){
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4*a1.value, sigmaY: 4*a1.value),
            child: Transform.translate(
              offset: Offset(0,(1-a1.value)*256),
              child: Transform.scale(
                scale: a1.value*0.75+0.25,
                child: Opacity(
                  opacity: a1.value,
                  child: Material(
                    color: Colors.transparent,
                    child: PopupDialog(
                      title: title,
                      message: message,
                      actions: actions,
                      isCancellable: isCancellable,
                    ),
                  )
                )
              )
            )
          );
        },
        transitionDuration: const Duration(milliseconds: 150),
        barrierDismissible: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                    width: min(360,MediaQuery.of(context).size.width-96),
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
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(0,0,0,0.75)
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        for(PopupAction action in actions)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: action.disabled ? null : () => action.onTap?.call(),
                              child: action.child,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 8)
                                ),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                  )
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary
                                )
                              ),
                            ),
                          ),
                      ],
                    )
                ),
              )
            ),
            if(isCancellable)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  child: Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(32))
                    ),
                    child: const Icon(Icons.close, color: Colors.black, size: 36,),
                  ),
                  onTapUp: (_){
                    Navigator.pop(context);
                  }
                ),
              )
          ],
        )
    );
  }
}

class PopupAction{
  Widget child;
  bool primary = false;
  Function? onTap;
  bool disabled = false;

  PopupAction({required this.child, this.primary=false,
    this.disabled=false, this.onTap});
}
