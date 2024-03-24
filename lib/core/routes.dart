import 'package:dohwaji/ui/flood_fill/flood_fill_raster_screen.dart';
import 'package:dohwaji/ui/intro/intro_page.dart';
import 'package:dohwaji/ui/select/select_page.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static String intro = '/';
  static String select = '/select';
  static String coloring = '/coloring';
}

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

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.intro,
      name: AppRoutes.intro,
      // builder: (context, state) => MyHomePage(title: 'testtest',),
      builder: (context, state) => IntroPage(),
    ),
    GoRoute(
      path: AppRoutes.select,
      name: AppRoutes.select,
      builder: (context, state) => ImageSelectPage(),
    ),
    GoRoute(
      path: AppRoutes.coloring,
      name: AppRoutes.coloring,
      builder: (context, GoRouterState state) {
        return FloodFillRasterScreen(
            index: state.uri.queryParameters['index'] ?? '');
      },
    ),
  ],
);
