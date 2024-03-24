// web_platform_specific.dart
import 'dart:typed_data';

import 'package:dohwaji/interface/common_interface.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  @override
  void downloadImage(Uint8List? image) async{
    if(image == null) return;

    await ImageGallerySaver.saveImage(image,quality: 100);
  }
}
