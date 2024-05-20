import 'package:dohwaji/core/keys.dart';
import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddToHome{

  OverlayEntry? a2hsOverlay;

  void showOverlay(){
    try{
      a2hsOverlay = OverlayEntry(
        builder: (context) => inducePopup(),
      );
      navigatorKey.currentState?.overlay?.insert(a2hsOverlay!);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Widget inducePopup(){
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: AppThemes.pointColor.withOpacity(0.8),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '공유 버튼으로 홈 화면에 추가하여 간편하게 이용해보세요!',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () async{
                  DateTime now = DateUtils.dateOnly(DateTime.now());
                  await GetStorage().write(Keys.HIDDEN_INDUCE_BANNER, now.toString());
                  a2hsOverlay?.remove();
                },
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SvgPicture.asset(
                    'assets/icons/ic_32_close.svg',
                    width: 16,
                    height: 16,
                    colorFilter: CommonUtil.svgFilter(Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}