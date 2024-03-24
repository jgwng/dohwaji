import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dohwaji/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showImageDownloadDialog(
    { required Uint8List? downloadImage}) async {
  await showDialog(
    context: globalContext,
    builder: (BuildContext context) {
      return ImageDownloadDialog(
        downloadImage: downloadImage,
      );
    },
  );
}

class ImageDownloadDialog extends StatefulWidget {
  const ImageDownloadDialog({super.key, required this.downloadImage});
  final Uint8List? downloadImage;

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

    _iframeElement.width = '$boxWidth';
   _iframeElement.height = '$boxHeight';
    _iframeElement.style.border = 'none';
    var url = Uri.dataFromBytes(widget.downloadImage!, mimeType: 'image/png').toString();
    dataUrl = url;
    _iframeElement.srcdoc = imageDocHtml(dataUrl, boxWidth, boxHeight);

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadDownloadImage().then((value) {
    //     try {
    //       if (value == null) return;
    //       var url = Uri.dataFromBytes(value, mimeType: 'image/png').toString();
    //       setState(() {
    //         dataUrl = url;
    //         boxHeight = 300;
    //
    //         _iframeElement.srcdoc = imageDocHtml(dataUrl, boxWidth, boxHeight);
    //         _iframeElement.height = '$boxHeight';
    //       });
    //     } catch (e) {
    //       AlertToast.show(msg: e.toString());
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 28,
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                'assets/icons/ic_32_close.svg',
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xffeeeeee))),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
          const Text(
            '캡쳐하거나 꾹 눌러 저장하세요! PC라면 마우스 우클릭!',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
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

  Widget downloadImagePreview() {
    if (dataUrl.isEmpty) {
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
