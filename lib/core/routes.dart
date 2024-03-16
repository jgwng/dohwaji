import 'package:dohwaji/ui/flood_fill/flood_fill_raster_screen.dart';
import 'package:dohwaji/ui/home_page.dart';
import 'package:dohwaji/ui/intro/intro_page.dart';
import 'package:dohwaji/ui/select/select_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes{
  static String intro = '/';
  static String select = '/select';
  static String coloring = '/coloring';
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
      builder: (context, state) => GridViewPage(),
    ),
    GoRoute(
      path: AppRoutes.coloring,
      name: AppRoutes.coloring,
      builder: (context, GoRouterState state){
        return FloodFillRasterScreen(
            index: state.uri.queryParameters['index'] ?? ''
        );
      },
    ),
  ],
);
