import 'package:dohwaji/core/resources.dart';
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


  @override
  void initState(){
    super.initState();
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
}
