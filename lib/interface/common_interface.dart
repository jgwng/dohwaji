import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class PlatformInterface {
  void useWebSpecificFeature();

  Future<void> saveAsSVG(String svgCode);

  bool get isPWAMode;

  int get statusBarHeight;

  void addEventListener(String type, Function? listener);

  void removeEventListener(String type, Function? listener);

  void downloadImage(Uint8List? image);
}
