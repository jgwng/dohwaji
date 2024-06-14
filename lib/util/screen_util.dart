import 'package:dohwaji/util/platform_util.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class ScreenUtil {
  double get screenWidth {
    if (PlatformUtil.isDesktopWeb) {
      double screenHeight = (html.window.innerWidth ?? 0).toDouble();
      if (screenHeight > 600) {
        return 600;
      } else {
        return screenHeight;
      }
    } else {
      return Get.width;
    }
  }
}

extension ScreenUtilExtension on num {
  double get w {
    return (this) * (ScreenUtil().screenWidth / 390);
  }

  double get fs {
    double screenWidth = ScreenUtil().screenWidth;
    const double baseScreenWidth = 390.0; // Standard screen width
    if (screenWidth > baseScreenWidth) {
      return toDouble();
    }
    double scaleFactor = screenWidth / baseScreenWidth;
    return this * scaleFactor;
  }
}
