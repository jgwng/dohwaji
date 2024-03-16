import 'package:dohwaji/core/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef FutureCallback = Future<void> Function();

class DefaultButton extends StatelessWidget {
  DefaultButton(
      {Key? key,
        required this.onTap,
        this.btnText,
        this.isReady,
        this.width,
        this.height,
        this.buttonColor,
        this.horizontalMargin,
        this.fontFamily,
        this.bottomMargin = 20})
      : super(key: key);

  final FutureCallback onTap;
  final bool? isReady;
  final String? btnText;
  final String? fontFamily;
  final Color? buttonColor;
  final double? bottomMargin;
  final double? horizontalMargin;
  final double? width;
  final double? height;

  RxBool isNetworking = false.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(isNetworking.isTrue) return;
        isNetworking.value = true;
        await onTap.call();
        isNetworking.value = false;
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomMargin ?? 0,
          left: horizontalMargin ?? 0,
          right: horizontalMargin ?? 0,
        ),
        child: Container(
          height: height ?? 56,
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: buttonColor ?? const Color(0xff7D5A50),

              borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Obx((){
            if(isNetworking.value){
              return const FittedBox(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return Text(btnText ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: fontFamily ?? AppFonts.medium,
                  fontSize: 20,));
          }),
        ),
      ),
    );
  }
}
