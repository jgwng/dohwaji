import 'package:dohwaji/ui/widget/default_button.dart';
import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:dohwaji/util/device_padding.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/web/web_platform_specific.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double bottom = 0;
  @override
  void initState(){
    bottom = bottomInset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: PlatformSafeArea(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'isPWA : ${PlatformUtil.isPWA}',
            ),
            DefaultButton(
              onTap: onTapButton,
            ),
            const Spacer(),
            Text(
              'bottom : $bottom',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTapButton() async{
    await Future.delayed(Duration(seconds: 1),(){});
  }
}
