
import 'package:dohwaji/core/route_observer.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import 'package:universal_html/html.dart';
class GlobalBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}
class GlobalController extends GetxController{
  bool? isBack = false;

  @override
  void onInit(){
   html.window.onPopState.listen((PopStateEvent event) {
     var hash = window.location.hash;
     if(ColorRouteObserver().hashList.contains(hash)){
       try{
         if (navigatorKey.currentState?.canPop() ?? false) {
           navigatorKey.currentState?.pop();
         } else {
           debugPrint("Attempted to pop when no routes could be popped.");
         }

       }catch(e){
         print(e.toString());
       }
     }else{

       window.history.replaceState(null, '도화지', ColorRouteObserver().lastPath);
       print('history : ${window.history}');
     }
    });
  }

}