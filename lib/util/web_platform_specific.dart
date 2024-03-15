// web_platform_specific.dart
import 'dart:convert';
import 'dart:html' as html;

void useWebSpecificFeature() {
  // Use dart:html features here
  html.window.alert("This is a web-specific feature.");
}

/// Works for `Web` only.
Future<void> saveAsSVG(String svgCode) async {
  html.AnchorElement()
    ..href =
        '${Uri.dataFromString(svgCode, mimeType: 'image/svg+xml', encoding: utf8)}'
    ..download = 'result.svg'
    ..style.display = 'none'
    ..click();
}

bool get isPWAMode{
  const mqStandAlone = '(display-mode: standalone)';
  if (html.window.matchMedia(mqStandAlone).matches) {
    return true;
  } else {
    return false;
  }
}

int get statusBarHeight{
  var  windowHeight = html.window.innerHeight;
  var documentHeight = html.document.documentElement?.clientHeight;
  var statusbar = (windowHeight ?? 0) - (documentHeight ?? 0);
  return statusbar;
}