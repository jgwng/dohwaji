import 'package:dohwaji/ui/flood_fill/flood_fill_raster_screen.dart';
import 'package:dohwaji/ui/intro/intro_page.dart';
import 'package:dohwaji/ui/select/select_page.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static String intro = '/';
  static String select = '/select';
  static String coloring = '/coloring';
}

Map<String, WidgetBuilder> colorRoutes = {
  AppRoutes.intro: (_) => const IntroPage(),
  AppRoutes.select: (_) => const ImageSelectPage(),
  AppRoutes.coloring: (_) => const FloodFillRasterScreen(),
};

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    // only return the child without warping it with animations
    return child!;
  }
}

PageTransitionsTheme get pageTransitionTheme {
  return PageTransitionsTheme(
    builders: {
      TargetPlatform.android: (PlatformUtil.isWeb)
          ? const NoTransitionsBuilder()
          : const ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: (PlatformUtil.isWeb)
          ? const NoTransitionsBuilder()
          : const CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: const NoTransitionsBuilder(),
      TargetPlatform.windows: const NoTransitionsBuilder()
    },
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext => navigatorKey.currentState!.context;