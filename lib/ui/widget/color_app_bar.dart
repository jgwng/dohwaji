import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColorAppBar extends StatelessWidget{
  ColorAppBar(
      {Key? key,
         this.onTap,
         this.title,
         this.isClose,
         this.action
      }) : super(key: key);

  final VoidCallback? onTap;
  final String? title;
  final bool? isClose;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppThemes.pointColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: FittedBox(
                child: SvgPicture.asset(
                  (isClose ?? false) ?  'assets/icons/ic_32_close.svg' :
                  'assets/icons/ic_32_back.svg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(title ?? '',
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                color: AppThemes.buttonTextColor,
                fontFamily: AppFonts.medium,
                fontSize: (PlatformUtil.isDesktopWeb ? 24 : 20).fs,
              )),
            ),
          ),
          action ?? const SizedBox(
            height: 32,
            width: 32,
          )
        ],
      ),
    );
  }
}