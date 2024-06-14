import 'package:dohwaji/core/resources.dart';
import 'package:flutter/material.dart';

class ColorToast extends StatelessWidget {
  const ColorToast({Key? key, required this.msg}) : super(key: key);
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          msg ?? '',
          style: const TextStyle(
              fontSize: 16,
              color: AppThemes.textColor,
              fontFamily: AppFonts.medium),
          softWrap: true,
        ),
      ),
    );
  }
}
