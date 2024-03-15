import "generic_platform_specific.dart"
if (dart.library.html) 'web_platform_specific.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PlatformUtil {
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
   return isPWAMode;
  }
}
