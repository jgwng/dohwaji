import 'package:dohwaji/ui/widget/add_to_home_overlay.dart';
import 'package:dohwaji/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_html/js.dart' as js;
import 'package:get/get.dart';
void addToHomeScreen() async{
  final prefs = GetStorage();
  const isWebDialogShownKey = "is-web-dialog-shown";
  final isWebDialogShown = prefs.read(isWebDialogShownKey) ?? false;
  if (!isWebDialogShown) {
    final bool isDeferredNotNull =
    js.context.callMethod("isDeferredNotNull") as bool;

    if (isDeferredNotNull) {
      debugPrint(">>> Add to HomeScreen prompt is ready.");
      await showAddHomePageDialog(Get.context!);
      prefs.write(isWebDialogShownKey, true);
    } else {
      debugPrint(">>> Add to HomeScreen prompt is not ready yet.");
    }
  }
}

void showA2HSOverlay(){
   AddToHome().showOverlay();
  // if(PlatformUtil.isPWA == false){
  //     AddToHome().showOverlay();
  // }
}

Future<bool?> showAddHomePageDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Icon(
                    Icons.add_circle,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  )),
              const SizedBox(height: 20.0),
              const Text(
                '홈 화면에 추가',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '바탕화면에 추가하시겠습니까?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    js.context.callMethod("presentAddToHome");
                    Get.back(result: false);
                  },
                  child: const Text("Yes!"))
            ],
          ),
        ),
      );
    },
  );
}
