import 'package:dohwaji/core/router.dart';
import 'package:dohwaji/init_setting.dart';
import 'package:dohwaji/ui/home_page.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

void main() async{
  await initAppSetting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isWeb) {
      return buildApp().animate().fadeIn(duration: 400.ms);
    }
    return buildApp();
  }

  Widget buildApp() {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        brightness: Brightness.light,
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        fontFamilyFallback: const ['Noto Sans SC'],
        canvasColor: Colors.white,
      ),
    );
  }
}

