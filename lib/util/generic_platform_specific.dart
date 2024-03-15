// web_platform_specific.dart
import 'dart:convert';

import 'package:get/get.dart';

void useWebSpecificFeature() {
  print("This is a web-specific feature.");
}

/// Works for `Web` only.
Future<void> saveAsSVG(String svgCode) async {

}

bool get isPWAMode{
 return false;
}

int get statusBarHeight{
 return Get.mediaQuery.padding.top.toInt();
}
