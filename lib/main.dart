import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/core/size_config.dart';
import 'package:dohwaji/init_setting.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

void main() async {
  await initAppSetting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if(defaultTargetPlatform == TargetPlatform.android ||defaultTargetPlatform == TargetPlatform.iOS){
        return  buildApp();
      }
      return FlutterWebFrame(
        maximumSize: SizeConfig().webMaxSize,
        backgroundColor: AppThemes.mobileBackgroundColor,
        builder: (context) {
          return buildApp();
        },
      );
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
    );
  }
}
