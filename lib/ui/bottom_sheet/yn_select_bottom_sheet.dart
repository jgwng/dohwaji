import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/core/routes.dart';
import 'package:flutter/material.dart';

Future<bool?> showYNSelectBottomSheet(
    {required String title, required String content}) async {
  final result = await showModalBottomSheet(
      context: globalContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (context) {
        return SelectYNBottomSheet(
          title: title,
          content: content,
        );
      });
  if (result != null) return result;
  return null;
}

class SelectYNBottomSheet extends StatelessWidget {
  const SelectYNBottomSheet(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppThemes.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: bottomButton(title: '아니오'),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: bottomButton(title: '예'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget bottomButton({
    required String title,
  }) {
    bool isCancel = title == '아니오';
    Color? btnColor = isCancel ? Colors.transparent : AppThemes.pointColor;
    Color titleColor = isCancel ? Colors.black : Colors.white;
    Color? borderColor =
        isCancel ? Color.fromRGBO(234, 234, 234, 1.0) : Colors.transparent;
    return InkWell(
      onTap: () {
        Navigator.pop(globalContext, !isCancel);
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: btnColor,
            borderRadius: BorderRadius.circular(12.0)),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: titleColor, fontSize: 18),
        ),
      ),
    );
  }
}
