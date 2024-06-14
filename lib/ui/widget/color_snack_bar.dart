import 'package:dohwaji/core/resources.dart';
import 'package:flutter/material.dart';

class ColorSnackbar extends StatefulWidget {
  final String msg;
  final int? second;

  const ColorSnackbar({Key? key, required this.msg, this.second})
      : super(key: key);

  @override
  _ColorSnackbarState createState() => _ColorSnackbarState();
}

class _ColorSnackbarState extends State<ColorSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward().then((value) async {
      Future.delayed(Duration(seconds: widget.second ?? 2))
          .then((value) => _animationController.reverse());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppThemes.pointColor,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            widget.msg,
            style: const TextStyle(
                fontSize: 16,
                color: AppThemes.textColor,
                fontFamily: AppFonts.medium),
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
