import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:dohwaji/util/device_padding.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/web/web_platform_specific.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
            const Spacer(),
            Text(
              'bottom : $bottom',
            ),
          ],
        ),
      ),
    );
  }
}
