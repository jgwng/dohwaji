import 'package:dohwaji/core/resources.dart';
import 'package:flutter/material.dart';

class DohwaJiCopyRightInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(
        bottom: 8
      ),
      alignment: Alignment.center,
      child: const Text(
        'Copyrightⓒ2024 Developer Woong.All rights reserved.',
        style: TextStyle(
          color: AppThemes.hintColor,
          fontFamily: AppFonts.medium,
          fontSize: 16
        ),
      ),
    );
  }
}