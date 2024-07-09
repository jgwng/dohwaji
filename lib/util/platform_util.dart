import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/interface/common_interface.dart';
import 'package:dohwaji/ui/flood_fill/helper/image_painter.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/general/generic_platform_specific.dart';
import 'package:dohwaji/util/web/web_platform_specific.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlatformUtil {
  static PlatformInterface get _platformInterface =>
      (kIsWeb) ? WebUtil() : GeneralUtil();

  static bool get isWeb {
    return kIsWeb;
  }

  static bool get isIOSWeb {
    bool isIOS = GetPlatform.isIOS;
    return isWeb == true && isIOS == true;
  }

  static bool get isAOSWeb {
    bool isAOS = GetPlatform.isAndroid;
    return isWeb == true && isAOS == true;
  }

  static bool get isIOSApp {
    bool isMobile = GetPlatform.isMobile;
    bool isIOS = GetPlatform.isIOS;
    return isMobile == true && isIOS == true;
  }

  static bool get isAOSApp {
    bool isMobile = GetPlatform.isMobile;
    bool isAOS = GetPlatform.isAndroid;
    return isMobile == true && isAOS == true;
  }

  static bool get isDesktopWeb {
    bool isWeb = GetPlatform.isWeb;
    bool isAOS = GetPlatform.isAndroid;
    bool isIOS = GetPlatform.isIOS;
    return isWeb == true && isAOS == false && isIOS == false;
  }

  static bool get isPWA {
    return _platformInterface.isPWAMode;
  }

  static void addEventListener(String type, Function? listener) {
    _platformInterface.addEventListener(type, listener);
  }

  static void removeEventListener(String type, Function? listener) {
    _platformInterface.removeEventListener(type, listener);
  }

  static void downloadImage(ui.Image? image) async {
    if (image == null) return;
    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    Uint8List? resultData = await CommonUtil.createImageFromWidget(
        CustomPaint(
          size: imageSize,
          painter: ImagePainter(image),
        ),
        globalContext,
        imageSize: imageSize,
        logicalSize: imageSize);

    _platformInterface.downloadImage(resultData);
  }

}
