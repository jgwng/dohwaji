import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;
class ColorRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final ColorRouteObserver _instance = ColorRouteObserver._internal();
  List<String> path = [];
  String? lastPath = html.window.location.pathname;

  // Private constructor
  ColorRouteObserver._internal();

  // Public factory constructor to access the singleton instance
  factory ColorRouteObserver() {
    return _instance;
  }

  void _saveScreenView({
    PageRoute<dynamic>? oldRoute,
    PageRoute<dynamic>? newRoute,
    String? routeType,
  }) {
    debugPrint(
        '[track] screen old : ${oldRoute?.settings.name}, new : ${newRoute?.settings.name}'
    );
  }

  PageRoute? checkPageRoute(Route<dynamic>? route) {
    return route is PageRoute ? route : null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      String newUrl = '${html.window.location.origin}/#${route.settings.name ?? ''}';
      path.add(route.settings.name ?? '');
      if ((route.settings.name ?? '') != '/') {
        CommonUtil.savePageParam(Get.arguments ?? {});
        lastPath = newUrl;
      }
    }

    _saveScreenView(
      newRoute: checkPageRoute(route),
      oldRoute: checkPageRoute(previousRoute),
      routeType: 'push',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      path.last = (newRoute.settings.name ?? '');
      String newUrl = '${html.window.location.origin}/#${newRoute.settings.name ?? ''}';
      CommonUtil.savePageParam(Get.arguments ?? {});
      lastPath = newUrl;
    }

    _saveScreenView(
      newRoute: checkPageRoute(newRoute),
      oldRoute: checkPageRoute(oldRoute),
      routeType: 'replace',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute) {
      path.removeLast();
    }

    _saveScreenView(
      newRoute: checkPageRoute(previousRoute),
      oldRoute: checkPageRoute(route),
      routeType: 'pop',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      path.removeLast();
    }

    _saveScreenView(
      newRoute: checkPageRoute(previousRoute),
      oldRoute: checkPageRoute(route),
      routeType: 'remove',
    );
  }
}