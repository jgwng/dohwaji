import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:dohwaji/ui/select/preview_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ImageSelectPage extends StatefulWidget {
  const ImageSelectPage({super.key});
  @override
  _ImageSelectPageState createState() => _ImageSelectPageState();
}

class _ImageSelectPageState extends State<ImageSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: const Text('이미지 선택', style: TextStyle(
          color: AppThemes.buttonTextColor,
          fontFamily: AppFonts.medium,
          fontSize: 20,
        )),
        elevation: 0,
        leading: InkWell(
          onTap: (){
            context.pop();
          },
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: FittedBox(
              child: SvgPicture.asset('assets/icons/ic_32_back.svg',
                width: 28,
                height: 28,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}
