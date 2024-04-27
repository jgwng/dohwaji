import 'dart:ui' as ui;

import 'package:dohwaji/ui/widget/color_snack_bar.dart';
import 'package:dohwaji/ui/widget/color_toast.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class CommonUtil {
  static Future<Uint8List?> createImageFromWidget(
      Widget widget, BuildContext context,
      {Duration? wait, Size? logicalSize, Size? imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??=
        View.of(context).physicalSize / View.of(context).devicePixelRatio;
    imageSize ??= View.of(context).physicalSize;

    // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      // window: null,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
      view: View.of(context),
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
    return result;
  }

  Future<void> loadFont(String font) async {
    FontLoader loader = FontLoader(font);
    // loader.addFont(rootBundle.load('assets/fonts/${qrFonts.fontFileName}'));
    loader.addFont(_fetchFont(font));
    await loader.load();
  }

  Future<ByteData> _fetchFont(String fontFileName) async {
    try {
      final response = await http.get(Uri.parse(
          'https://cdn.jsdelivr.net/gh/jgwng/web_fonts/$fontFileName.woff'));
      if (response.statusCode == 200) {
        return ByteData.view(response.bodyBytes.buffer);
      } else {
        throw Exception('Failed to load font');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static String urlWithParams(String route, Map<String, dynamic> parameters) {
    route = '$route?';
    parameters.forEach((key, value) {
      route += '$key=${value.toString()}';
    });
    return route;
  }

  static void setStatusBarColor(Color color) {
    if (PlatformUtil.isWeb) {
      CommonUtil.runJSFunction('setMetaThemeColor', color.toStatusHex());
      // js.context.callMethod('setMetaThemeColor', [color.toStatusHex()]);
    } else {

    }
  }
  static void showToast({required String msg, required BuildContext context, int seconds = 2}) async {
    OverlayEntry _overlay = OverlayEntry(builder: (_) => ColorToast(msg: msg));
    Overlay.of(context).insert(_overlay);
    await Future.delayed(Duration(seconds: seconds));
    _overlay.remove();
  }

  static void showSnackBar(
      {required String msg,
        required BuildContext context,
        int seconds = 2}) async {
    OverlayEntry _overlay =
    OverlayEntry(builder: (_) => ColorSnackbar(msg: msg));
    Overlay.of(context).insert(_overlay);
  }
  static bool useWhiteForeground(Color backgroundColor) =>
      1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;





  static void runJSFunction(String fnName,dynamic parameter){
    // Create a script element
    final script = html.ScriptElement()
      ..type = 'application/javascript';

    // Correctly serialize the parameter, assuming it's a string for this context
    final parameterSerialized = parameter is String ? "'$parameter'" : parameter.toString();

    // Set the script content to call the function with the parameter
    script.text = '$fnName($parameterSerialized);';

    // Append the script to the document body to execute it
    html.document.body?.children.add(script);

    // Remove the script element after a short delay to ensure execution
    Future.delayed(const Duration(milliseconds: 10), () {
      script.remove();
    });
  }

  static void savePageParam(Map<String, dynamic> params) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final nowUrl = html.window.location.href;
      final index =
          nowUrl.indexOf(html.window.location.host) + html.window.location.host.length;

      Map<String, String> strMap = {};
      for (final key in params.keys) {
        final value = params[key];
        if (value == null) continue;
        strMap[key] = value.toString();
      }

      String path = html.window.location.href.substring(index, nowUrl.length);
      String uri = Uri(path: '', queryParameters: strMap).toString();

      if (path.contains('?')) {
        final deleteIndex = path.indexOf('?');
        final deleteStr = path.substring(deleteIndex, path.length);
        path = path.replaceAll(deleteStr, '');
      }

      html.window.history.replaceState(null, '도화지', '$path$uri');
    });
  }
}

extension ColorExtension on Color {
  String toStatusHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
