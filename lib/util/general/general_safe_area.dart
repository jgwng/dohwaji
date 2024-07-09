import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/cupertino.dart';

class PlatformSafeArea extends StatelessWidget {
  PlatformSafeArea(
      {super.key,
        this.top,
        this.bottom,
        this.left,
        this.right,
        this.maintainBottomViewPadding,
        this.child});
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;
  final bool? maintainBottomViewPadding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: top ?? true,
      bottom: bottom ?? true,
      left: left ?? true,
      right: right ?? true,
      child: child ?? Container(),
    );
  }
}
