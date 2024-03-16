import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CommonUtil{
  static Future<Uint8List?> createImageFromWidget(Widget widget,
      {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      // window: null,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
      view: ui.window,
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    // final BuildOwner buildOwner = BuildOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    // //final Rect rect = canvasKey.globalPaintBounds!;
    // await Future<dynamic>.delayed(const Duration(milliseconds: 800));
    // final int scale = 2;

    final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    var result = byteData?.buffer.asUint8List();
    return byteData?.buffer.asUint8List();
  }

  Future<void> loadFont(String font) async{
    FontLoader loader = FontLoader(font);
    // loader.addFont(rootBundle.load('assets/fonts/${qrFonts.fontFileName}'));
    loader.addFont(_fetchFont(font));
    await loader.load();
  }

  Future<ByteData> _fetchFont(String fontFileName) async{
    try{
      final response = await http.get(
          Uri.parse('https://cdn.jsdelivr.net/gh/jgwng/web_fonts/$fontFileName.woff'));
      if(response.statusCode == 200){
        return ByteData.view(response.bodyBytes.buffer);
      }else{
        throw Exception('Failed to load font');
      }
    }catch(e){
      throw Exception(e);
    }
  }
}