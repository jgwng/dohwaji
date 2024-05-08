import 'package:dohwaji/core/route_observer.dart';
import 'package:dohwaji/ui/flood_fill/flood_fill_controller.dart';
import 'package:dohwaji/ui/flood_fill/helper/image_painter.dart';
import 'package:dohwaji/ui/widget/color_app_bar.dart';
import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:dohwaji/ui/widget/torn_tape_painter.dart';
import 'package:dohwaji/util/common_util.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:dohwaji/util/screen_util.dart';
import 'package:dohwaji/util/storage_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FloodFillRasterScreen extends StatefulWidget {
  const FloodFillRasterScreen({super.key});

  @override
  State<FloodFillRasterScreen> createState() => _FloodFillRasterState();
}

class _FloodFillRasterState extends State<FloodFillRasterScreen> {
  RxBool isWorking = false.obs;
  late FloodFillController controller;
  String? tag;
  @override
  void initState() {
    super.initState();
    tag = DateTime.now().toIso8601String();
    controller = Get.put<FloodFillController>(FloodFillController(),tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformSafeArea(
        child: Column(
          children: [
            ColorAppBar(
              onTap: controller.onTapBack,
              title: '색칠하기',
              action: InkWell(
                onTap: () async{
                  await controller.capturePng();
                },
                child: FittedBox(
                  child: SvgPicture.asset(
                    'assets/icons/ic_32_download.svg',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: buildBody(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          // alignment: Alignment.center,
          children: [
            Container(
              width: imageSize,
              height: imageSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(27, 29, 31, 0.1),
                      blurRadius: 10.0,
                      offset: Offset(0, 6.0),
                      spreadRadius: 0.0, // Adjust as needed
                    ),
                  ],
                  border: Border.all(color: const Color(0xffeeeeee)),
                  borderRadius: BorderRadius.circular(8)),
              child: drawingWidget(),
            ),
            Positioned(
              left: ((imageSize/2)-50),
              top: (-14.0).w,
              child: CustomPaint(
                painter: TornPaperPainter(),
                size: const Size(100, 40),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          width: imageSize,
          child: GridView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) => InkWell(
              onTap: () {
                controller.currentColor.value = index;
              },
              child: Obx(() {
                return Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: controller.colorList[index],
                      borderRadius: BorderRadius.circular(8.0)),
                  child: (index == controller.currentColor.value)
                      ? FittedBox(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: SvgPicture.asset(
                              CommonUtil.useWhiteForeground(
                                      controller.colorList[index])
                                  ? 'assets/icons/ic_32_check_black.svg'
                                  : 'assets/icons/ic_32_check_white.svg',
                              width: 28,
                              height: 28,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                      : const SizedBox(),
                );
              }),
            ),
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 60 / 60,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget drawingWidget() {
    return RepaintBoundary(
      key: controller.imageKey,
      child: Container(
        width: imageSize,
        height: imageSize,
        alignment: Alignment.center,
        child: Obx(() {
          if (controller.originalImage.value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FittedBox(
            child: GestureDetector(
              onTapDown: controller.onFillColor,
              child: CustomPaint(
                size: Size(controller.originalImage.value!.width.toDouble(),
                    controller.originalImage.value!.height.toDouble()),
                painter: ImageTransitionPainter(
                    image1: controller.image1.value!,
                    image2: controller.image2.value!,
                    animationValue: controller.fillController!.value),
              ),
            ),
          );
        }),
      ),
    );
  }

  double get imageSize{
    if(PlatformUtil.isDesktopWeb == false){
      return (Get.width-32).w;
    }else{
      if(ScreenUtil().screenWidth == 600){
        return 400;
      }else{
        return (Get.width-32).w;
      }
    }
  }
}
