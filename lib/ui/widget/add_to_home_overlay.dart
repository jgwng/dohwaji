import 'package:dohwaji/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddToHome{

  OverlayEntry? a2hsOverlay;

  void showOverlay(){
    try{
      a2hsOverlay = OverlayEntry(
        builder: (context) => inducePopup(),
      );
      navigatorKey.currentState?.overlay?.insert(a2hsOverlay!);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Widget inducePopup(){
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.blue.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '공유 버튼으로 홈 화면에 추가하여 간편하게 이용해보세요!',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}