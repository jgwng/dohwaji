import 'package:flutter/material.dart';
import 'package:dohwaji/util/general/general_ui.dart' if (dart.library.html) 'package:dohwaji/util/web/web_ui.dart' as ui;
import 'package:universal_html/html.dart' as html;

class CachedImage extends StatefulWidget {

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

  const CachedImage({
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
  _WebNetworkImageState createState() => _WebNetworkImageState();
}

class _WebNetworkImageState extends State<CachedImage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late String viewType;
  final ValueNotifier<double> opacityRatio = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    viewType = 'cached-image-${widget.url.hashCode}';

    ui.platformViewRegistry.registerViewFactory(
      viewType,
          (int viewId) {
        final imgElement = html.ImageElement()
          ..src = widget.url
          ..width = widget.width.toInt()
          ..height = widget.height.toInt()
          ..style.objectFit = widget.fit.toString().split('.').last
          ..style.border = widget.border.toString()
          ..style.borderRadius = '8'
          ..style.width = widget.width.toString()
          ..style.height = widget.height.toString()
          ..style.filter = widget.filterColor != null ? 'filter: ${widget.filterColor.toString()}' : '';

        imgElement.onLoad.listen((event) {
          // Start the animation when the image is loaded
          _controller.forward();
        });
        return imgElement;
      },
    );
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(progressListener);

  }

  void progressListener() {
    final value = (_animation.value) ?? 0;
    if (value > 0) {
      opacityRatio.value = value;
    }
  }

  @override
  void dispose(){

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: ValueListenableBuilder(
          valueListenable: opacityRatio,
          builder: (context,value,child){
            return Opacity(
              opacity: _animation.value,
              child: HtmlElementView(
                  viewType: viewType),
            );
          },
        )
      ),
    );
  }
}