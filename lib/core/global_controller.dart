import 'package:dohwaji/add_to_home_screen.dart';
import 'package:dohwaji/core/route_observer.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}

class GlobalController extends GetxController {
  bool? isBack = false;

  @override
  void onInit() {
    initWebSetting();
  }

  void initWebSetting() {
    if (PlatformUtil.isWeb == false) return;
    window.addEventListener('beforeinstallprompt', (e) {
      e.preventDefault();
      BeforeInstallPromptEvent event = e as BeforeInstallPromptEvent;
      print('deferredPrompt Global : $event');
    });
    if (PlatformUtil.isDesktopWeb) {
      window.history.pushState(null, '도화지', window.location.href);
      window.onPopState.listen((event) {
        window.history.go(1);
      });
    } else {
      window.onPopState.listen((PopStateEvent event) {
        var hash = window.location.hash;
        if (ColorRouteObserver().hashList.contains(hash)) {
          try {
            if (navigatorKey.currentState?.canPop() ?? false) {
              navigatorKey.currentState?.pop();
            } else {
              debugPrint("Attempted to pop when no routes could be popped.");
            }
          } catch (e) {
            print(e.toString());
          }
        } else {
          window.history
              .replaceState(null, '도화지', ColorRouteObserver().lastPath);
        }
      });
    }
  }
}
