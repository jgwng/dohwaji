
import 'package:dohwaji/core/route_observer.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/platform_util.dart';
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
    initWebSetting();
  }


  void initWebSetting(){
    if(PlatformUtil.isWeb == false) return;

    if(PlatformUtil.isDesktopWeb){
      html.window.history.pushState(null, '도화지', html.window.location.href);
      html.window.onPopState.listen((event) {

        html.window.history.go(1);
      });
    }else{
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
        }
      });
    }

  }




}