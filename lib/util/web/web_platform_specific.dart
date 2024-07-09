// web_platform_specific.dart
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:dohwaji/util/general/general_ui.dart' if (dart.library.html) 'package:dohwaji/util/general/web_ui.dart' as ui;
import 'package:dohwaji/interface/common_interface.dart';
import 'package:dohwaji/ui/download/image_download_dialog.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebUtil extends PlatformInterface {
  @override
  void useWebSpecificFeature() {
    // Use dart:html features here
    html.window.alert("This is a web-specific feature.");
  }

  /// Works for `Web` only.
  @override
  Future<void> saveAsSVG(String svgCode) async {
    html.AnchorElement()
      ..href =
          '${Uri.dataFromString(svgCode, mimeType: 'image/svg+xml', encoding: utf8)}'
      ..download = 'result.svg'
      ..style.display = 'none'
      ..click();
  }

  @override
  bool get isPWAMode {
    const mqStandAlone = '(display-mode: standalone)';
    if (html.window.matchMedia(mqStandAlone).matches) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get statusBarHeight {
    var windowHeight = html.window.innerHeight;
    var documentHeight = html.document.documentElement?.clientHeight;
    var statusbar = (windowHeight ?? 0) - (documentHeight ?? 0);
    return statusbar;
  }

  @override
  void addEventListener(String type, Function? listener) {
    html.window.addEventListener(type, (event) async {
      if (listener != null) {
        listener();
      }
    });
  }

  @override
  void removeEventListener(String type, Function? listener) {
    html.window.removeEventListener(type, (event) async {
      if (listener != null) {
        listener();
      }
    });
  }

  @override
  void downloadImage(Uint8List? image) {
    if (image == null) return;
    if (PlatformUtil.isDesktopWeb == true) {
      final base64data = base64Encode(image);

      // then we create and AnchorElement with the html package
      final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

      // set the name of the file we want the image to get
      // downloaded to
      a.download = 'download.jpg';

      // and we click the AnchorElement which downloads the image
      a.click();
      // finally we remove the AnchorElement
      a.remove();
    } else {
      showImageDownloadDialog(downloadImage: image);
    }
  }

  @override
  Widget networkImageWidget(){
    return CachedImageWeb(
      url: 'https://picsum.photos/250?image=9',
      width: 300,
      height: 300,
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
class CachedImageWeb extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final BoxFit? fit;
  final Color? filterColor;
  final FilterQuality? filterQuality;
  final Color? placeHolderColor;
  final Alignment? alignment;
  final bool useCacheKey;

  const CachedImageWeb({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.isCircular = false,
    this.fit,
    this.filterColor,
    this.filterQuality,
    this.placeHolderColor,
    this.alignment,
    this.useCacheKey = false,
  });

  @override
  Widget build(BuildContext context) {
    final viewType = 'cached-image-${url.hashCode}';

    ui.platformViewRegistry.registerViewFactory(
      viewType,
          (int viewId) {
        final imgElement = html.ImageElement()
          ..src = url
          ..width = width.toInt()
          ..height = height.toInt()
          ..style.objectFit = fit.toString().split('.').last
          ..style.border = border.toString()
          ..style.borderRadius = borderRadius!.toString()
          ..style.filter = filterColor != null ? 'filter: ${filterColor.toString()}' : '';

        return imgElement;
      },
    );

    return HtmlElementView(viewType: viewType);
  }
}
