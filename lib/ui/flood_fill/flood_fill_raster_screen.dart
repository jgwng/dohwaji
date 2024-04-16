import 'dart:io';
import 'dart:ui' as ui;

import 'package:dohwaji/ui/bottom_sheet/yn_select_bottom_sheet.dart';
import 'package:dohwaji/ui/flood_fill/image_flood_fill_queue_impl.dart';
import 'package:dohwaji/ui/flood_fill/image_painter.dart';
import 'package:dohwaji/ui/widget/color_app_bar.dart';
import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/storage_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class FloodFillRasterScreen extends StatefulWidget {
  const FloodFillRasterScreen({super.key, required this.imageIndex});

  final String imageIndex;

  @override
  State<FloodFillRasterScreen> createState() => _FloodFillRasterState();
}

class _FloodFillRasterState extends State<FloodFillRasterScreen>
    with SingleTickerProviderStateMixin {
  ui.Image? _image;
  RxBool isWorking = false.obs;
  ui.Image? _image1;
  ui.Image? _image2;

  AnimationController? _controller;
  bool isInitialized = true;
  bool isDirty = false;
  int colorIndex = 0;

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

  @override
  void initState() {
    super.initState();
    _loadImage().then((image) {
      setState(() {
        _image = image;
        _image1 = image;
        _image2 = image;
      });
    });
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    PlatformUtil.addEventListener('beforeunload', saveTempData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInitialized == true) {
        isInitialized = false;
      }
    });
  }

  @override
  void dispose() {
    PlatformUtil.removeEventListener('beforeunload', saveTempData);
    super.dispose();
  }

  Future<void> saveTempData() async {
    if (isInitialized == false) {
      Uint8List? result = await CommonUtil.createImageFromWidget(
          CustomPaint(
            size: Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
            painter: ImagePainter(_image2!),
          ),
          context,
          imageSize:
              Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
          logicalSize:
              Size(_image2!.width.toDouble(), _image2!.height.toDouble()));
      if (result != null) {
        String list = String.fromCharCodes(result);
        LocalStorage().save('list', list);
      }
    }
  }

  Future<ui.Image> _loadImage() async {
    Uint8List? colorImage;
    bool hasTempData = LocalStorage().contain('list') ?? false;
    if (hasTempData == true) {
      colorImage = await getTempData();
    }

    if (colorImage == null) {
      // const url =
      //     'https://sun9-77.userapi.com/impg/BiGYCxYxSuZgeILSzA0dtPcNC7935fdhpW36rg/e3jk6CqTwkw.jpg?size=1372x1372&quality=95&sign=2afb3d42765f8777879e06c314345303&type=album';
      // // final http.Response result = await http.get(Uri.parse('https://upload.wikimedia.org/wikipedia/commons/b/b4/Chess_ndd45.svg'));

      // final response = await http.get(Uri.parse(url));
      int index = int.tryParse(widget.imageIndex ?? '0') ?? -1;
      if (index < 0) index = 0;

      final ByteData testData = await rootBundle
          .load('assets/images/example_image_${index ?? 0}.jpg');
      colorImage = testData.buffer.asUint8List();
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

  void _onTapDown(TapDownDetails details) async {
    if (isWorking.isTrue) return;
    isWorking.value = true;
    if(isDirty == false){
      isDirty = true;
    }
    final Offset localPosition = details.localPosition;
    final int x = localPosition.dx.toInt();
    final int y = localPosition.dy.toInt();
    final image = await ImageFloodFillQueueImpl(_image1!)
        .fill(x, y, colorList[colorIndex]);
    if (image == null) return;
    setState(() {
      _image = image;
      _image2 = image;
      _controller!.forward().then((value) {
        _controller!.reset();
        _image1 = image;
      });
      isWorking.value = false;
    });
  }

  Future<img.Image?> convertUiImageToImagePackageImage(ui.Image uiImage) async {
    // Convert ui.Image to ByteData
    final ByteData? byteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    // Convert ByteData to Uint8List
    final Uint8List uint8list = byteData.buffer.asUint8List();

    // Use the image package to decode the Uint8List
    img.Image? image = img.decodeImage(uint8list);

    return image;
  }

  GlobalKey globalKey = GlobalKey();


  Future<void> _capturePng() async {
    try {
      PlatformUtil.downloadImage(_image2);
    } catch (e) {
      CommonUtil.showToast(msg: e.toString(),context: context, seconds: 10);
    }
  }

  Future<Uint8List?> _fetchNetworkToUint8List() async {
    try {
      http.Response _response =
          await http.get(Uri.parse("https://picsum.photos/200/300/?blur"));
      if (_response.statusCode == 200) {
        Uint8List _unit8List = _response.bodyBytes;
        return _unit8List;
      } else {
        return null;
      }
    } on HttpException catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformSafeArea(
        child: Column(
          children: [
            ColorAppBar(
              onTap: () async{
                if(isDirty == false){
                  context.pop();
                }else{
                  bool? result = await showYNSelectBottomSheet(
                    title: '그리고 있던 그림을 저장할까요?',
                    content: '저장하면 다음에 이어 그릴수 있어요!'
                  );
                  if(result == true){
                    context.pop();
                  }
                }
              },
              title: '색칠하기',
            ),
            Expanded(
              child: buildBody(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody(){
    if (_image == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffeeeeee)),
              borderRadius: BorderRadius.circular(8)),
          child: drawingWidget(),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: 332,
          child: GridView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) => InkWell(
              onTap: () {
                setState(() {
                  colorIndex = index;
                });
              },
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: colorList[index],
                    borderRadius: BorderRadius.circular(8.0)),
                child: (index == colorIndex)
                    ? FittedBox(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: SvgPicture.asset(
                      CommonUtil.useWhiteForeground(colorList[index])
                          ? 'assets/icons/ic_32_check_black.svg'
                          : 'assets/icons/ic_32_check_white.svg',
                      width: 28,
                      height: 28,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
                    : const SizedBox(),
              ),
            ),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 60 / 60,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            _capturePng();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 163, 70, 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              '이미지 저장',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () async {
                _capturePng();
                return;
                // var testResult = await imageToBytes(_image2!);
                // var list = testResult?.buffer.asUint32List();

                // list = Uint8List.fromList(list!);
                // // Uint8List? _image = await _fetchNetworkToUint8List();
              },
              child: Container(
                height: 60,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 163, 70, 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                child: const Text(
                  '이미지 업로드 테스트',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  Widget drawingWidget() {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        width: 300,
        height: 300,
        alignment: Alignment.centerLeft,
        child: FittedBox(
          child: GestureDetector(
            onTapDown: _onTapDown,
            child: CustomPaint(
              size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
              painter: ImageTransitionPainter(
                  image1: _image1!,
                  image2: _image2!,
                  animationValue: _controller!.value),
            ),
          ),
        ),
      ),
    );
  }
}
