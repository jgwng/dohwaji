
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/ui/select/image_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
class ColoringPreview extends StatefulWidget {
  ColoringPreview({required this.index});

  final int index;

  @override
  _ColoringPreviewState createState() => _ColoringPreviewState();
}

class _ColoringPreviewState extends State<ColoringPreview> {
  Uint8List? coloringImage;

  @override
  void didChangeDependencies() async{
    // Adjust the provider based on the image type
    await precacheImage(CachedNetworkImageProvider(webAssetUrl), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        double screenWidth = (html.window.innerWidth ?? 0).toDouble();
        print('screenWidth : $screenWidth');
        // final controller =Get.find<ImageSelectController>();
        // controller.onTapColorImage(widget.index);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffe6e6e6))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage( imageUrl: webAssetUrl),
        ),
      ),
    );
  }

  // String get webAssetUrl => '${window.location.origin}/assets/$assetUrl';
  String get webAssetUrl => 'https://cdn.jsdelivr.net/gh/jgwng/dohwaji/$assetUrl';
  String get assetUrl => 'assets/images/example_image_${widget.index}.jpg';
}
