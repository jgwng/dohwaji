import 'package:dohwaji/ui/bottom_sheet/yn_select_bottom_sheet.dart';
import 'package:dohwaji/ui/flood_fill/util/image_flood_fill_queue_impl.dart';
import 'package:dohwaji/ui/flood_fill/helper/image_painter.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/storage_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class FloodFillController extends GetxController with GetSingleTickerProviderStateMixin{
  List<Color> colorList = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.deepPurple,
    Colors.pink,
    Colors.lightGreen,
    Colors.tealAccent
  ];


  bool isInitialized = true;
  bool isDirty = false;
  AnimationController? fillController;
  GlobalKey imageKey = GlobalKey();
  int _imageIndex = -1;


  RxInt currentColor = 0.obs;
  RxBool isLoading = false.obs;

  Rx<ui.Image?> originalImage = Rx<ui.Image?>(null);
  Rx<ui.Image?> image1 = Rx<ui.Image?>(null);
  Rx<ui.Image?> image2 = Rx<ui.Image?>(null);

  @override
  void onInit(){
    super.onInit();

    fillController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        image1.refresh();
        image2.refresh();
      });
    PlatformUtil.addEventListener('beforeunload', saveTempData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInitialized == true) {
        isInitialized = false;
      }
    });
  }

  @override
  void onReady() async{
    isLoading.value = true;
    ui.Image? image = await _loadImage();
    originalImage.value = image;
    image1.value = image;
    image2.value = image;
    isLoading.value = false;
  }

  @override
  void onClose(){
    super.onClose();
    PlatformUtil.addEventListener('beforeunload', saveTempData);
  }
  Future<ui.Image> _loadImage() async {
    Uint8List? colorImage;
    bool hasTempData = LocalStorage().contain('list') ?? false;
    if (hasTempData == true) {
      colorImage = await getTempData();
    }

    if (colorImage == null) {
      if (_imageIndex < 0) _imageIndex = 0;
      final http.Response result = await http.get(Uri.parse('https://cdn.jsdelivr.net/gh/jgwng/dohwaji/assets/images/example_image_$_imageIndex.jpg'));
      colorImage = result.bodyBytes;
    }

    // _photo = img.decodeImage(list);
    final ui.Codec codec = await ui.instantiateImageCodec(colorImage);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<Uint8List?> getTempData() async {
    String? temp = await LocalStorage().read('list');
    if (temp != null) {
      final List<int> codeUnits = temp.codeUnits;
      return Uint8List.fromList(codeUnits);
    } else {
      return null;
    }
  }

  Future<void> saveTempData() async {
    if (isInitialized == false) {
      if(image2.value == null) return;
      Size imageSize = Size(image2.value!.width.toDouble(), image2.value!.height.toDouble());
      Uint8List? result = await CommonUtil.createImageFromWidget(
          CustomPaint(
            size: imageSize,
            painter: ImagePainter(image2.value!),
          ),
          Get.context!,
          imageSize: imageSize,
          logicalSize: imageSize);
      if (result != null) {
        String list = String.fromCharCodes(result);
        LocalStorage().save('list', list);
      }
    }
  }

  void onFillColor(TapDownDetails details) async {
    if(isDirty == false){
      isDirty = true;
    }
    final Offset localPosition = details.localPosition;
    final int x = localPosition.dx.toInt();
    final int y = localPosition.dy.toInt();
    final image = await ImageFloodFillQueueImpl(image1.value!)
        .fill(x, y, colorList[currentColor.value]);
    if (image == null) return;
    originalImage.value = image;
    image2.value = image;
    fillController!.forward().then((value) {
      fillController!.reset();
      image1.value = image;
    });
  }

  Future<void> capturePng() async {
    try {
      PlatformUtil.downloadImage(image2.value);
    } catch (e) {
      CommonUtil.showToast(msg: e.toString(),context: Get.context!, seconds: 10);
    }
  }

  void onTapBack() async{
    if(isDirty == false){
      Get.back();
    }else{
      bool? result = await showYNSelectBottomSheet(
          title: '그리고 있던 그림을 저장할까요?',
          content: '저장하면 다음에 이어 그릴수 있어요!'
      );
      if(result == true){
        var result = await convertUiImageToUint8List();
        Get.back(result: result);
      }
    }
  }

  Future<Uint8List?> convertUiImageToUint8List() async{
    final ByteData? byteData =
    await (image2.value)!.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    // Convert ByteData to Uint8List
    final Uint8List list = byteData.buffer.asUint8List();
    return list;
  }


}