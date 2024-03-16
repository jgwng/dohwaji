import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dohwaji/ui/flood_fill/flood_fill_interface.dart';
import 'package:dohwaji/ui/flood_fill/image_helper.dart';
import 'package:flutter/material.dart';

class ImageFloodFillSpanImpl extends FloodFill<ui.Image, ui.Color> {
  ImageFloodFillSpanImpl(ui.Image image) : super(image);

  @override
  Future<ui.Image?> fill(int startX, int startY, ui.Color newColor) async {
    ByteData? byteData = await imageToBytes(image);
    if (byteData == null) return null;

    int width = image.width;
    int height = image.height;
    ui.Color targetColor = getPixelColor(bytes: byteData, x: startX, y: startY, imageWidth: width);

    var s = <List<int>>[];

    print('isBlack == ${targetColor == Colors.black}');
    print('targetColor == $targetColor');
    print('newColor == $newColor');


    bool isAlmostBlack = isAlmostSameColor(pixelColor: targetColor, checkColor: Colors.black,threshold: 33);
    bool isAlmostSameWithBlack = isColorSimilarToBlack(targetColor);

    if(!isAlmostBlack && !isAlmostSameWithBlack){
      s.add([startX, startX, startY, 1]);
      s.add([startX, startX, startY - 1, -1]);
    }

    while (s.isNotEmpty) {
      var tuple = s.removeLast();
      var x1 = tuple[0];
      var x2 = tuple[1];
      var y = tuple[2];
      var dy = tuple[3];

      var nx = x1;
      if (_isInside(nx, y, width, height, byteData, targetColor)) {
        while (_isInside(nx - 1, y, width, height, byteData, targetColor)) {
          setPixelColor(x: nx - 1, y: y, bytes: byteData, imageWidth: width, newColor: newColor,oldColor: targetColor);
          nx--;
        }
        if (nx < x1) {
          s.add([nx, x1 - 1, y - dy, -dy]);
        }
      }

      while (x1 <= x2) {
        while (_isInside(x1, y, width, height, byteData, targetColor)) {
          setPixelColor(x: x1, y: y, bytes: byteData, imageWidth: width, newColor: newColor,oldColor: targetColor);
          x1++;
        }
        if (x1 > nx) {
          s.add([nx, x1 - 1, y + dy, dy]);
        }
        if (x1 - 1 > x2) {
          s.add([x2 + 1, x1 - 1, y - dy, -dy]);
        }
        x1++;
        while (x1 < x2 && !_isInside(x1, y, width, height, byteData, targetColor)) {
          x1++;
        }
        nx = x1;
      }
    }

    return imageFromBytes(byteData, width, height);
  }

  bool _isInside(int x, int y, int width, int height, ByteData bytes, ui.Color targetColor) {
    if (x < 0 || x >= width || y < 0 || y >= height) return false;
    return isAlmostSameColor(pixelColor: getPixelColor(bytes: bytes, x: x, y: y, imageWidth: width), checkColor: targetColor);
  }

  bool isColorSimilarToBlack(ui.Color color) {
    // Define your threshold for similarity to black here
    // This is a simple example where we consider a color similar to black
    // if all RGB values are below 50 (on a scale from 0 to 255)
    const int threshold = 100;
    return color.red < threshold && color.green < threshold && color.blue < threshold;
  }
}