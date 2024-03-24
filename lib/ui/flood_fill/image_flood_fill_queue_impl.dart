import 'package:dohwaji/ui/flood_fill/flood_fill_interface.dart';
import 'package:dohwaji/ui/flood_fill/image_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:collection';
import 'package:image/image.dart' as img;

class ImageFloodFillQueueImpl extends FloodFill<ui.Image, ui.Color> {
  ImageFloodFillQueueImpl(ui.Image image) : super(image);

  @override
  Future<ui.Image?> fill(int startX, int startY, ui.Color newColor) async {
    ByteData? byteData = await imageToBytes(image);
    if (byteData == null) return null;
    int width = image.width;
    int height = image.height;

    if (isSimilarColor(
        bytes: byteData,
        x: startX,
        y: startY,
        imageWidth: width,
        standardColor: newColor)) {
      return image;
    }
    ui.Color oldColor =
        getPixelColor(bytes: byteData, x: startX, y: startY, imageWidth: width);
    if (isColorSimilarToBlack(oldColor)) {
      return image;
    }

    final Queue<Point> queue = Queue();
    queue.add(Point(startX, startY));

    while (queue.isNotEmpty) {
      final Point point = queue.removeFirst();
      final int x = point.x;
      final int y = point.y;
      var pixelColor =
          getPixelColor(bytes: byteData, x: x, y: y, imageWidth: width);
      if (isAlmostSameColor(
          pixelColor:
              getPixelColor(bytes: byteData, x: x, y: y, imageWidth: width),
          checkColor: oldColor,
          threshold: 50)) {
        setPixelColor(
            x: x,
            y: y,
            bytes: byteData,
            imageWidth: width,
            newColor: newColor,
            oldColor: oldColor);
        if (x > 0) {
          queue.add(Point(x - 1, y));
        }
        if (x < width - 1) {
          queue.add(Point(x + 1, y));
        }
        if (y > 0) {
          queue.add(Point(x, y - 1));
        }
        if (y < height - 1) queue.add(Point(x, y + 1));
      }
    }
    return imageFromBytes(byteData, width, height);
  }

  Future<ByteData?> fillData(int startX, int startY, ui.Color newColor) async {
    ByteData? byteData = await imageToBytes(image);
    if (byteData == null) return null;
    int width = image.width;
    int height = image.height;

    if (isSimilarColor(
        bytes: byteData,
        x: startX,
        y: startY,
        imageWidth: width,
        standardColor: newColor)) {
      return byteData;
    }
    ui.Color oldColor =
        getPixelColor(bytes: byteData, x: startX, y: startY, imageWidth: width);
    if (isColorSimilarToBlack(oldColor)) {
      return byteData;
    }

    final Queue<Point> queue = Queue();
    queue.add(Point(startX, startY));

    while (queue.isNotEmpty) {
      final Point point = queue.removeFirst();
      final int x = point.x;
      final int y = point.y;
      var pixelColor =
          getPixelColor(bytes: byteData, x: x, y: y, imageWidth: width);
      if (isAlmostSameColor(
          pixelColor:
              getPixelColor(bytes: byteData, x: x, y: y, imageWidth: width),
          checkColor: oldColor,
          threshold: 50)) {
        setPixelColor(
            x: x,
            y: y,
            bytes: byteData,
            imageWidth: width,
            newColor: newColor,
            oldColor: oldColor);
        if (x > 0) {
          queue.add(Point(x - 1, y));
        }
        if (x < width - 1) {
          queue.add(Point(x + 1, y));
        }
        if (y > 0) {
          queue.add(Point(x, y - 1));
        }
        if (y < height - 1) queue.add(Point(x, y + 1));
      }
    }
    return byteData;
    // return imageFromBytes(byteData, width, height);
  }

  bool needToChangePixelColor(byteData, startX, startY, width, newColor) {
    ui.Color oldColor =
        getPixelColor(bytes: byteData, x: startX, y: startY, imageWidth: width);

    bool isSimilarToBlack = isColorSimilarToBlack(oldColor);
    bool isSimilarToNew = isAlmostSameColor(
        pixelColor: oldColor, checkColor: newColor, threshold: 50);

    return isSimilarToNew || isSimilarToBlack;

    return false;
  }

  bool isColorSimilarToBlack(ui.Color color) {
    // Define your threshold for similarity to black here
    // This is a simple example where we consider a color similar to black
    // if all RGB values are below 50 (on a scale from 0 to 255)
    const int threshold = 100;
    return color.red < threshold &&
        color.green < threshold &&
        color.blue < threshold;
  }

  bool isSameColor(ui.Color oldColor, ui.Color newColor) {
    return (oldColor.red == newColor.red) &&
        (oldColor.green == newColor.green) &&
        (oldColor.blue == newColor.blue);
  }
}

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);
}
