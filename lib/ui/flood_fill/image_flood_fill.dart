import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dohwaji/ui/flood_fill/flood_fill_interface.dart';
import 'package:dohwaji/ui/flood_fill/image_helper.dart';

class ImageFloodFill extends FloodFill<ui.Image, ui.Color> {
  ImageFloodFill(ui.Image image) : super(image);

  @override
  Future<ui.Image?> fill(int startX, int startY, ui.Color newColor) async {
    ByteData? byteData = await imageToBytes(image);
    if (byteData == null) return null;

    int width = image.width;
    int height = image.height;
    ui.Color originalColor =
        getPixelColor(bytes: byteData, x: startX, y: startY, imageWidth: width);

    _floodFillUtil(
        byteData, startX, startY, width, height, originalColor, newColor);

    return imageFromBytes(byteData, width, height);
  }

  void _floodFillUtil(ByteData bytes, int x, int y, int width, int height,
      ui.Color originalColor, ui.Color newColor) {
    var oldColor = getPixelColor(bytes: bytes, x: x, y: y, imageWidth: width);
    // Check if current node is inside the boundary and not already filled
    if (!_isInside(x, y, width, height) ||
        !isAlmostSameColor(pixelColor: oldColor, checkColor: originalColor))
      return;

    // Set the node
    setPixelColor(
        x: x,
        y: y,
        bytes: bytes,
        imageWidth: width,
        newColor: newColor,
        oldColor: oldColor);

    // Perform flood-fill one step in each direction
    _floodFillUtil(
        bytes, x + 1, y, width, height, originalColor, newColor); // East
    _floodFillUtil(
        bytes, x - 1, y, width, height, originalColor, newColor); // West
    _floodFillUtil(
        bytes, x, y - 1, width, height, originalColor, newColor); // North
    _floodFillUtil(
        bytes, x, y + 1, width, height, originalColor, newColor); // South
  }

  bool _isInside(int x, int y, int width, int height) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }
}
