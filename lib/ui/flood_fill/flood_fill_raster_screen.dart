import 'package:dohwaji/ui/flood_fill/flood_fill_controller.dart';
import 'package:dohwaji/ui/flood_fill/image_painter.dart';
import 'package:dohwaji/ui/widget/color_app_bar.dart';
import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:dohwaji/ui/widget/torn_tape_painter.dart';
import 'package:dohwaji/util/common_util.dart';
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

  @override
  void initState() {
    super.initState();
    int imageIndex = Get.arguments?['index'] ?? -1;
    if(imageIndex != -1){
      controller = Get.put<FloodFillController>(FloodFillController(),tag: '$imageIndex');
    }

  }

  @override
  void dispose() {
    super.dispose();
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
          children: [
            FittedBox(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffeeeeee)),
                    borderRadius: BorderRadius.circular(8)),
                child: drawingWidget(),
              ),
            ),
            Positioned(
              left: (332/2)-40,
              top: -20,
              child: CustomPaint(
                painter: TornPaperPainter(),
                size: const Size(80, 32),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: 332,
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
        InkWell(
          onTap: () async {
            controller.capturePng();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 163, 70, 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              '이미지 저장',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () async {
                controller.capturePng();
                return;
              },
              child: Container(
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 163, 70, 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                child: const Text(
                  '이미지 업로드 테스트',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget drawingWidget() {
    return RepaintBoundary(
      key: controller.imageKey,
      child: Container(
        width: 300,
        height: 300,
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
}
