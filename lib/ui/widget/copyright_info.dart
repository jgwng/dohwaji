import 'package:universal_html/html.dart';

import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';

class DohwaJiCopyRightInfo extends StatelessWidget {
  const DohwaJiCopyRightInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      color: const Color(0xfff8f8f8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Design & develop by',
            style: TextStyle(
                color: Color(0xff666666),
                fontFamily: AppFonts.medium,
                fontSize: 16),
          ),
          const SizedBox(
            width: 2,
          ),
          InkWell(
            onTap: (){
              if(PlatformUtil.isWeb){
                window.open('https://github.com/jgwng', '', '',);
              }
            },
            child: const Text(
              'Jung GunWoong',
              style: TextStyle(
                  color: Color(0xff666666),
                  fontFamily: AppFonts.medium,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
