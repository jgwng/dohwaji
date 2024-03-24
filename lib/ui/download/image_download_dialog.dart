import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/alert_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showImageDownloadDialog(
{required BuildContext context, required ui.Image? downloadImage}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ImageDownloadDialog(
        downloadImage: downloadImage,
      );
    },
  );
}



class ImageDownloadDialog extends StatefulWidget {
  ImageDownloadDialog({required this.downloadImage});
  final ui.Image? downloadImage;

  @override
  _ImageDownloadState createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownloadDialog> {
  late Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();
  late String initId;

  String dataUrl = '';

  double boxHeight = 300;
  double boxWidth = 300;

  @override
  void initState() {
    initId = 'initId';

    _iframeElement.height = '300';
    _iframeElement.width = '$boxWidth';
    _iframeElement.srcdoc = imageDocHtml('', 400, boxHeight);
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'initId',
          (int viewId) {
        return _iframeElement;
      },
    );
    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: initId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDownloadImage().then((value){
        try{
          if(value == null) return;
          var url =
          Uri.dataFromBytes(value, mimeType: 'image/png').toString();
          setState(() {
            dataUrl = url;
            boxHeight = 300;

            _iframeElement.srcdoc =
                imageDocHtml(dataUrl, boxWidth, boxHeight);
            _iframeElement.height = '$boxHeight';
          });
        }catch(e){
          AlertToast.show(msg:e.toString());
        }
      });
    });

  }

  Future<Uint8List?> loadDownloadImage() async{
    if(widget.downloadImage == null) return null;
    Uint8List? result = await CommonUtil.createImageFromWidget(
        CustomPaint(
          size: Size(widget.downloadImage!.width.toDouble(), widget.downloadImage!.height.toDouble()),
          painter: ImagePainter(widget.downloadImage!),
        ),
        context,
        imageSize: Size(widget.downloadImage!.width.toDouble(), widget.downloadImage!.height.toDouble()),
        logicalSize: Size(widget.downloadImage!.width.toDouble(), widget.downloadImage!.height.toDouble())
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(12),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 28,
            alignment: Alignment.centerRight,
            child:SvgPicture.asset(
                'assets/icons/ic_32_close.svg',
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    color: const Color(0xffeeeeee)
                )
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 16),
            child: FittedBox(
              child: AnimatedOpacity(
                opacity: dataUrl.isEmpty ? 0.0 : 1.0,
                duration: const Duration(seconds: 1),
                child: downloadImagePreview(),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text('캡쳐하거나 꾹 눌러 저장하세요! PC라면 마우스 우클릭!',style: TextStyle(
            fontSize: 16,
          ),),
        ],
      ),
    );
  }

  String imageDocHtml(String url, double width, double height) {
    return '''
<html>
<head>
<style>
img {
  display: block;
  position:absolute;
  top:0;
  right:0;
  bottom:0;
  left:0;  
}
</style>
</head>
<body>

<img src= $url  width="$width" height="$height" style="display: block; margin: 0px auto;">

</body>
</html>
    ''';
  }



  Widget downloadImagePreview(){
    if(dataUrl.isEmpty){
      return Container(
        width: 300,
        height: boxHeight,
        color: Colors.red,
      );
    }
    return Container(
      // color: const Color(0xffffffff),
      height: boxHeight,
      width: 300,
      alignment: Alignment.center,
      child: _iframeWidget,
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