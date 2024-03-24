// web_platform_specific.dart
import 'dart:convert';

import 'package:dohwaji/interface/common_interface.dart';
import 'package:get/get.dart';

class GeneralUtil extends PlatformInterface {
  @override
  void useWebSpecificFeature() {
    print("This is a web-specific feature.");
  }

  /// Works for `Web` only.
  @override
  Future<void> saveAsSVG(String svgCode) async {}

  @override
  bool get isPWAMode {
    return false;
  }

  @override
  int get statusBarHeight {
    return Get.mediaQuery.padding.top.toInt();
  }

  @override
  void addEventListener(String type, Function? listener) {}

  @override
  void removeEventListener(String type, Function? listener) {}
}
