import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<ByteData?> imageToBytes(ui.Image image) async{
  final bytes = await image.toByteData();
  return bytes;
}

Future<ui.Image> imageFromBytes(ByteData bytes, int imageWidth, int imageHeight){
  final Completer<ui.Image> completer = Completer();
  var list = bytes.buffer.asUint8List();
  ui.decodeImageFromPixels(
    list,
    imageWidth,
    imageHeight,
    ui.PixelFormat.rgba8888,
        (img) {
      completer.complete(img);
    },
  );
  return completer.future;
}

void setPixelColor({
  required int x,
  required int y,
  required ByteData bytes,

  // for correct representation of color bytes' coordinates
  // in an array of image bytes
  required int imageWidth,
  required ui.Color newColor,
  required ui.Color oldColor
}) {
  bytes.setUint32(
    (x + y * imageWidth) * 4, // offset
    colorToIntRGBA(newColor,oldColor), // value
  );
}

ui.Color getPixelColor({
  required ByteData bytes,
  required int x,
  required int y,
  required int imageWidth,
}) {
  final uint32 = bytes.getUint32((x + y * imageWidth) * 4);
   return colorFromIntRGBA(uint32);
}

int colorToIntRGBA(ui.Color newColor,ui.Color oldColor) {
    // print('isAlmostSame : ${isAlmostSameColor(pixelColor: newColor, checkColor: oldColor)}');
    // print('oldColor : $oldColor');
    // print('newColor : $newColor');
  if(isAlmostSameColor(pixelColor: newColor, checkColor: oldColor,threshold: 50)){
    return oldColor.value;
  }else{
    return getIntRGBAValue(newColor);
  }
}

int getIntRGBAValue(ui.Color color){
  // Extract ARGB components
  int a = (color.value >> 24) & 0xFF;
  int r = (color.value >> 16) & 0xFF;
  int g = (color.value >> 8) & 0xFF;
  int b = color.value & 0xFF;
  // Convert to RGBA and combine into a single integer
  return (r << 24) | (g << 16) | (b << 8) | a;
}

ui.Color colorFromIntRGBA(int uint32Rgba) {
  // Extract RGBA components
  int r = (uint32Rgba >> 24) & 0xFF;
  int g = (uint32Rgba >> 16) & 0xFF;
  int b = (uint32Rgba >> 8) & 0xFF;
  int a = uint32Rgba & 0xFF;

  Color standardColor = Colors.yellow;
  // print(colorToUint32Rgba(standardColor));
  // print( getIntRGBAValue(standardColor));
  // print(uint32Rgba);
  // print('---------');
  // print('${standardColor.red}, ${standardColor.green}, ${standardColor.blue}, ${standardColor.alpha}');
  // print('$r, $g, $b, $a');
  // print('${img.uint32ToRed(uint32Rgba)}, ${img.uint32ToGreen(uint32Rgba)}, ${img.uint32ToBlue(uint32Rgba)}, ${img.uint32ToAlpha(uint32Rgba)}');
  // print('${standardColor.alpha}, ${standardColor.red}, ${standardColor.green}, ${standardColor.blue}');
  //
  //
  // print(ui.Color.fromARGB(a, r, g, b));
  // print(ui.Color.fromARGB(img.uint32ToAlpha(uint32Rgba), img.uint32ToRed(uint32Rgba), img.uint32ToGreen(uint32Rgba), img.uint32ToBlue(uint32Rgba)));
  //
  // print(ui.Color.fromARGB(a, r, g, b) == standardColor);
  // print(ui.Color.fromARGB(a, r, g, b).value == standardColor.value);
  // print(ui.Color.fromARGB(img.uint32ToAlpha(uint32Rgba), img.uint32ToRed(uint32Rgba), img.uint32ToGreen(uint32Rgba), img.uint32ToBlue(uint32Rgba)) == standardColor);
  // print(ui.Color.fromARGB(img.uint32ToAlpha(uint32Rgba), img.uint32ToRed(uint32Rgba), img.uint32ToGreen(uint32Rgba), img.uint32ToBlue(uint32Rgba)).value == standardColor.value);

  // Convert to ARGB format and create a Color object
  return ui.Color.fromARGB(a, r, g, b);
}

bool isAlmostSameColor({
  required ui.Color pixelColor,
  required ui.Color checkColor,
  int? threshold = 99
  // required int imageWidth,
}) {
  threshold ??= 99;
  final int rDiff = (pixelColor.red - checkColor.red).abs();
  final int gDiff = (pixelColor.green - checkColor.green).abs();
  final int bDiff = (pixelColor.blue - checkColor.blue).abs();
  return rDiff < (threshold) && gDiff < threshold && bDiff < threshold;
}
int colorToUint32Rgba(Color color) {
  // Extract ARGB components
  int a = color.alpha;
  int r = color.red;
  int g = color.green;
  int b = color.blue;

  // Combine components into RGBA format
  int rgba = (r << 24) | (g << 16) | (b << 8) | a;
  return rgba;
}
bool isAvoidColor({
  required ui.Color pixelColor,
}) {
  int touchR = pixelColor.red;
  int touchG = pixelColor.green;
  int touchB = pixelColor.blue;
  int touchA = pixelColor.alpha;

  int red = Colors.black.red;
  int green = Colors.black.green;
  int blue = Colors.black.blue;
  int alpha = Colors.black.alpha;

  return red >= (touchR - 100) &&
      red <= (touchR + 100) &&
      green >= (touchG - 100) &&
      green <= (touchG + 100) &&
      blue >= (touchB - 100) &&
      blue <= (touchB + 100) &&
      alpha >= (touchA - 100) &&
      alpha <= (touchA + 100);
}

bool isSimilarColor(
{
  required ByteData bytes,
  required int x,
  required int y,
  required int imageWidth,
  required Color standardColor
}){
  final uint32Rgba = bytes.getUint32((x + y * imageWidth) * 4);
  Color beforePaintedColor = Color.fromARGB(img.uint32ToRed(uint32Rgba), img.uint32ToGreen(uint32Rgba), img.uint32ToBlue(uint32Rgba), img.uint32ToAlpha(uint32Rgba));
  Color newPaintedColor = colorFromIntRGBA(uint32Rgba);
  return beforePaintedColor.value == standardColor.value || newPaintedColor.value == standardColor.value;
}