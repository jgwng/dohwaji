import 'dart:math';

import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/ui/dialog/auth_dialog.dart';
import 'package:dohwaji/ui/widget/copyright_info.dart';
import 'package:dohwaji/ui/widget/default_button.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<String> introTitleList = [
    '색깔로 채워지는\n행복한 순간들을 함께해요',
    '색칠로 마법 같은 이야기를\n시작해 볼까요?',
    '오늘은 어떤 색으로\n기분을 표현할까요?',
    '너만의 색감으로\n멋진 작품을 완성해봐요!',
    '상상 속의 세계를\n현실로 만들어보는 시간이야!'
  ];
  int titleIndex = 0;
  @override
  void initState() {
    titleIndex = Random().nextInt(introTitleList.length);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                title(),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Flexible(
                        child: DefaultButton(
                          onTap: () async {
                            showSignUpDialog(context);
                          },
                          btnText: '로그인',
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: DefaultButton(
                          onTap: () async {
                            showSignUpDialog(context);
                          },
                          btnText: '회원 가입',
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.select);
                  },
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Colors.grey[200]!,
                        )
                      )
                    ),
                    child: const Text('로그인하지 않고 둘러보기',style:TextStyle(
                      color: Color(0xff828592),
                      fontFamily: AppFonts.medium,
                      fontSize: 16,
                      decoration: TextDecoration.underline
                    ),),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const DohwaJiCopyRightInfo()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget title() {
    String? title;
    double? fontSize;
    if (PlatformUtil.isDesktopWeb) {
      title = '오늘은 어떤 색을 사용해 볼까?\n너의 상상력을 마음껏 펼쳐봐!';
      fontSize = 32;
    } else {
      title = introTitleList[titleIndex];
      fontSize = 24;
    }
    return Container(
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: fontSize,
            color: AppThemes.textColor,
            fontFamily: AppFonts.bold),
      ),
    );
  }
}
