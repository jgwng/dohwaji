import 'package:dohwaji/core/global_controller.dart';
import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/route_observer.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/init_setting.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_strategy/url_strategy.dart';

void main() async {
  await initAppSetting();
  setHashUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return buildApp();
  }

  Widget buildApp() {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: '도화지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppThemes.pointColor),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        brightness: Brightness.light,
        //초기 StatusBar 색상 설정 되는 값
        primarySwatch:
            CommonUtil().createMaterialColor(AppThemes.backgroundColor),
        pageTransitionsTheme: pageTransitionTheme,
        useMaterial3: false,
        scaffoldBackgroundColor: AppThemes.backgroundColor,
        fontFamilyFallback: AppFonts.fontFamilyFallback,
        canvasColor: AppThemes.backgroundColor,
      ),
      routes: colorRoutes,
      initialRoute: '/',
      initialBinding: GlobalBinding(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? Container(),
        );
      },
      navigatorObservers: [ColorRouteObserver()],
    );
  }
}
