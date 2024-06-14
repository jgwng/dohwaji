import 'package:dohwaji/core/routes.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ImageSelectController extends GetxController {
  RxList<Uint8List> recentImageList = <Uint8List>[].obs;

  void onTapColorImage(int index) async {
    var result =
        await Get.toNamed(AppRoutes.coloring, arguments: {'index': index});
    if (result is Uint8List) {
      recentImageList.insert(0, result);
      recentImageList.refresh();
    }
  }

  void onTapSavedImage(int index) async {
    var result = await Get.toNamed(AppRoutes.coloring,
        arguments: {'savedData': recentImageList[index]});
    if (result is Uint8List) {
      recentImageList[index] = result;
      recentImageList.refresh();
    }
  }
}
