import 'package:dohwaji/add_to_home_screen.dart';
import 'package:dohwaji/firebase_options.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:universal_html/html.dart';

//앱 시작하기전 초기 세팅 해주는 함수
Future<void> initAppSetting() async {
  // 서버나 SharedPreferences 등 비동기로 데이터를 다룬 다음 runApp을 실행해야하는 경우
  final binding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  document.fonts?.onLoadingDone.listen((event) {
    print('events');
  });
  await GetStorage.init();
  // binding.deferFirstFrame();
  // binding.addPostFrameCallback((_) async {
  //   Future.wait([
  //     CommonUtil().loadFont(AppFonts.bold),
  //     CommonUtil().loadFont(AppFonts.medium),
  //     // CommonUtil().loadFont(AppFonts.regular),
  //     // CommonUtil().loadFont(AppFonts.semiBold),
  //   ]);
  //   binding.allowFirstFrame();
  // });
  GestureBinding.instance.resamplingEnabled = false;

  if(PlatformUtil.isWeb){
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      CommonUtil.runJSFunction('removeSplashLogo', null);

      if(PlatformUtil.isDesktopWeb){
        addToHomeScreen();
      } else if(PlatformUtil.isIOSWeb && PlatformUtil.isPWA == false){
        showA2HSOverlay();
      }
    });
  }
}
