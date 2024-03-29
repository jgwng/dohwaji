import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ColoringPreview extends StatefulWidget {
  ColoringPreview({required this.index});

  final int index;

  @override
  _ColoringPreviewState createState() => _ColoringPreviewState();
}

class _ColoringPreviewState extends State<ColoringPreview> {
  @override
  void didChangeDependencies() {
    // Adjust the provider based on the image type
    if(PlatformUtil.isWeb){
      precacheImage(NetworkImage(assetUrl), context);
    }else{
      precacheImage(AssetImage(assetUrl), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed(AppRoutes.coloring,
            queryParameters: {'index': '${widget.index}'});
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
          child: (PlatformUtil.isWeb)
              ? Image.network(assetUrl) : Image.asset(assetUrl),
        ),
      ),
    );
  }

  String get assetUrl => 'assets/images/example_image_${widget.index}.jpg';
}
