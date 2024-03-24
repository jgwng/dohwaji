import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/init_setting.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

void main() async {
  await initAppSetting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isWeb) {
      return FlutterWebFrame(
        maximumSize: const Size(600, 800),
        backgroundColor: AppThemes.mobileBackgroundColor,
        builder: (context) {
          return buildApp();
        },
      ).animate().fadeIn(duration: 400.ms);
    }
    return buildApp();
  }

  Widget buildApp() {
    return MaterialApp.router(
      title: '도화지',
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        brightness: Brightness.light,
        //초기 StatusBar 색상 설정 되는 값
        primarySwatch:
            CommonUtil().createMaterialColor(AppThemes.backgroundColor),
        pageTransitionsTheme: pageTransitionTheme,
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        fontFamilyFallback: const ['Noto Sans SC'],
        canvasColor: Colors.white,
      ),
    );
  }
}
