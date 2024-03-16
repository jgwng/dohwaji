import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dohwaji/ui/flood_fill/image_flood_fill_queue_impl.dart';
import 'package:dohwaji/util/alert_toast.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/storage_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class FloodFillRasterScreen extends StatelessWidget {
  const FloodFillRasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: const Text('Flood Fill Raster'),
      ),
      body: const Center(child: FloodFillRaster()),
    );
  }
}

class FloodFillRaster extends StatefulWidget {
  const FloodFillRaster({super.key});

  @override
  State<FloodFillRaster> createState() => _FloodFillRasterState();
}

class _FloodFillRasterState extends State<FloodFillRaster> with SingleTickerProviderStateMixin  {
  ui.Image? _image;
  bool _isWorking = false;
  ui.Image? _image1;
  ui.Image? _image2;

  AnimationController? _controller;
  RxBool isCheckColorMode = false.obs;
  bool isInitialized = true;

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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    PlatformUtil.addEventListener('beforeunload',saveTempData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(isInitialized == true){
        isInitialized = false;
      }
    });
  }

  @override
  void dispose(){
    PlatformUtil.removeEventListener('beforeunload',saveTempData);
    super.dispose();
  }

  Future<void> saveTempData() async{
    if(isInitialized == false){
      Uint8List? result = await CommonUtil.createImageFromWidget(
          CustomPaint(
            size: Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
            painter: ImagePainter(_image2!),
          ),
          imageSize: Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
          logicalSize: Size(_image2!.width.toDouble(), _image2!.height.toDouble())
      );
      if(result != null){
        String list = String.fromCharCodes(result);
        LocalStorage().save('list',list);
      }
    }
  }

  Future<ui.Image> _loadImage() async {
    Uint8List? colorImage;
    bool hasTempData = LocalStorage().contain('list') ?? false;
    if(hasTempData == true){
      colorImage = await getTempData();
    }

    if(colorImage == null){
      // const url =
      //     'https://sun9-77.userapi.com/impg/BiGYCxYxSuZgeILSzA0dtPcNC7935fdhpW36rg/e3jk6CqTwkw.jpg?size=1372x1372&quality=95&sign=2afb3d42765f8777879e06c314345303&type=album';
      // // final http.Response result = await http.get(Uri.parse('https://upload.wikimedia.org/wikipedia/commons/b/b4/Chess_ndd45.svg'));

      // final response = await http.get(Uri.parse(url));

      final ByteData testData = await rootBundle.load('assets/example_image.jpg');
      colorImage = testData.buffer.asUint8List();
    }

    // _photo = img.decodeImage(list);
    final ui.Codec codec = await ui.instantiateImageCodec(colorImage);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<Uint8List?> getTempData() async{
    String? temp = await LocalStorage().read('list');
    if(temp != null){
      final List<int> codeUnits = temp.codeUnits;
      return Uint8List.fromList(codeUnits);
    }else{
      return null;
    }
  }

  void _onTapDown(TapDownDetails details) async {
    if(_isWorking == true) return;
    _isWorking = true;
    final Offset localPosition = details.localPosition;
    final int x = localPosition.dx.toInt();
    final int y = localPosition.dy.toInt();
    const ui.Color newColor = Colors.yellow;

    if(isCheckColorMode.value){
      _isWorking = false;
    }else{
      final image = await ImageFloodFillQueueImpl(_image1!).fill(x, y, newColor);
      if(image == null) return;
      setState(() {
        _image = image;
        _image2 = image;
        _controller!.forward().then((value){
          _controller!.reset();
          _image1 = image;

        });
        _isWorking = false;
      });
    }
   }
  Future<img.Image?> convertUiImageToImagePackageImage(ui.Image uiImage) async {
    // Convert ui.Image to ByteData
    final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    // Convert ByteData to Uint8List
    final Uint8List uint8list = byteData.buffer.asUint8List();

    // Use the image package to decode the Uint8List
    img.Image? image = img.decodeImage(uint8list);

    return image;
  }
  GlobalKey globalKey = GlobalKey();

  void _saveNetworkImage() async {
    String path =
        'https://firebasestorage.googleapis.com/v0/b/goo2geul-ea689.appspot.com/o/test%2F2024-03-06T00%3A20%3A55.523.jpeg?alt=media&token=26ee44d8-859a-4940-9d10-78824c9d14a4';
    var result = await http.get(Uri.parse(path));
    final saveResult = await ImageGallerySaver.saveImage(
        result.bodyBytes,quality: 100);
    print(result);
  }

  Future<void> _capturePng() async {
   try{

     // RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
     // ui.Image image = await boundary.toImage();
     // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
     // Uint8List pngBytes = byteData!.buffer.asUint8List();


     Uint8List? result = await CommonUtil.createImageFromWidget(
         CustomPaint(
           size: Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
           painter: ImagePainter(_image2!),
         ),
         imageSize: Size(_image2!.width.toDouble(), _image2!.height.toDouble()),
         logicalSize: Size(_image2!.width.toDouble(), _image2!.height.toDouble())
     );

     // // ByteData? data =  await imageToBytes(_image2!);
     // // Uint8List? result = data?.buffer.asUint8List();
     print(result.toString());
     if (result != null) {
       await FirebaseStorage.instance.ref("test/${DateTime.now().toIso8601String()}.jpeg").putData(result);

       AlertToast.show(msg: 'uploadDone');
     }
   }catch(e){
     AlertToast.show(msg: e.toString(),seconds: 10);
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
    if (_image == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawingWidget(),
          InkWell(
            onTap: () async{
              _capturePng();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
              decoration: BoxDecoration(
                  color:const Color.fromRGBO(240, 163, 70, 1.0),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: const Text('이미지 저장',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),),
            ),
          ),
         Row(
           children: [
             InkWell(
               onTap: () async{

                 _capturePng();
                 return;
                 // var testResult = await imageToBytes(_image2!);
                 // var list = testResult?.buffer.asUint32List();

                 // list = Uint8List.fromList(list!);
                 // // Uint8List? _image = await _fetchNetworkToUint8List();

               },
               child: Container(
                 height: 60,
                 padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                 decoration: BoxDecoration(
                     color:const Color.fromRGBO(240, 163, 70, 1.0),
                     borderRadius: BorderRadius.circular(8.0)
                 ),
                 child: const Text('이미지 업로드 테스트',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 20,
                   ),),
               ),
             ),
             InkWell(
               onTap: () async{
                 isCheckColorMode.toggle();
               },
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                 decoration: BoxDecoration(
                     color:const Color.fromRGBO(240, 163, 70, 1.0),
                     borderRadius: BorderRadius.circular(8.0)
                 ),
                 child:  Obx((){
                   return Text(isCheckColorMode.isTrue ? "색상값 확인" : "색상값 변경",
                     textAlign: TextAlign.center,
                     style: const TextStyle(
                       color: Colors.white,
                       fontSize: 20,
                     ),);
                 }),
               ),
             )
           ],
         )
        ],
      ),
    );
  }
  Widget drawingWidget(){
    return  RepaintBoundary(
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
                  animationValue: _controller!.value
                  ),
            ),
          ),
        ),
      ),
    );
    if(_image2 == null){
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
                painter: ImagePainter(_image!),
              ),
            ),
          ),
        ),
      );
    }
    return  RepaintBoundary(
      key: globalKey,
      child: Container(
        width: 300,
        height: 300,
              child: FittedBox(
                child: CustomPaint(
                  size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
                  painter: ImagePainter(_image!),
                ),
              ),
      ),
    );

  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  const ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint()..filterQuality = FilterQuality.high);
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => true;
}

class ImageTransitionPainter extends CustomPainter {
  final ui.Image image1;
  final ui.Image image2;
  final double animationValue;

  ImageTransitionPainter({
    required this.image1,
    required this.image2,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Draw the first image
    paint.color = Color.fromRGBO(255, 0, 0, 1-animationValue);
    canvas.drawImage(image1, Offset.zero, paint);

    // Draw the second image with opacity based on the animation valuezzz
    paint.color = Color.fromRGBO(255, 0, 0, 1);
    canvas.drawImage(image2, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant ImageTransitionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
