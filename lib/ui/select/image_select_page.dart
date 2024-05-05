import 'package:cached_network_image/cached_network_image.dart';
import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/ui/select/image_select_controller.dart';
import 'package:dohwaji/ui/select/preview_image_widget.dart';
import 'package:dohwaji/ui/widget/color_app_bar.dart';
import 'package:dohwaji/ui/widget/platform_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ImageSelectPage extends StatefulWidget {
  const ImageSelectPage({super.key});
  @override
  _ImageSelectPageState createState() => _ImageSelectPageState();
}

class _ImageSelectPageState extends State<ImageSelectPage> {

  late ImageSelectController controller;

  @override
  void initState(){
    super.initState();
    controller = Get.put<ImageSelectController>(ImageSelectController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      body: PlatformSafeArea(
        child: Column(
          children: [
            ColorAppBar(
              onTap: Get.back,
              title: '이미지 선택',
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                //웹에서 스크롤바 노출 시키지 않도록 설정
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 80,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Obx((){
                          if(controller.recentImageList.isEmpty){
                            return const SizedBox();
                          }

                          return SizedBox(
                            height: 160,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 40),
                              separatorBuilder: (ctx,i){
                                return const SizedBox(
                                  width: 16,
                                );
                              },
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx,index){
                                return Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xffe6e6e6))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(controller.recentImageList[index]),
                                  ),
                                );
                              },
                              itemCount: controller.recentImageList.length,
                            ),
                          );
                        }),
                      ),
                      SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 100 / 100),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return ColoringPreview(index: index);
                            },
                            childCount: 8,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  String get webAssetUrl => 'https://cdn.jsdelivr.net/gh/jgwng/dohwaji/$assetUrl';
  String get assetUrl => 'assets/images/example_image_1.jpg';

}
