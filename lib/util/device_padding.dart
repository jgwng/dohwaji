@JS()
library safe_area;

import 'package:js/js.dart';

@JS('bottomInset')
external double bottomInset();

@JS('topInset')
external double topInset();

@JS('leftInset')
external double leftInset();

@JS('rightInset')
external double rightInset();