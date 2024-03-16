import 'package:dohwaji/ui/flood_fill/flood_fill_raster_screen.dart';
import 'package:dohwaji/ui/home_page.dart';
import 'package:go_router/go_router.dart';
GoRouter appRouter = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => MyHomePage(title: 'testtest',),
    // ),
    GoRoute(
      path: '/',
      builder: (context, state) => FloodFillRasterScreen(),
    ),
  ],
);
