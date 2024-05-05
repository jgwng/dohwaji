import 'package:dohwaji/ui/flood_fill/util/flood_fill_interface.dart';

class FloodFillSpanImpl extends FloodFill<List<List<int>>, int> {
  const FloodFillSpanImpl(List<List<int>> image) : super(image);

  // Check if the point is inside the canvas and matches the target color
  bool _isInside(int x, int y, int targetColor) {
    return x >= 0 &&
        y >= 0 &&
        x < image.length &&
        y < image[0].length &&
        image[x][y] == targetColor;
  }

  // Set a point to the replacement color
  void _setColor(int x, int y, int replacementColor) {
    image[x][y] = replacementColor;
  }

  @override
  List<List<int>>? fill(int startX, int startY, int newColor) {
    final targetColor = image[startX][startY];

    if (!_isInside(startX, startY, targetColor)) return null;

    var s = <List<int>>[];
    s.add([startX, startX, startY, 1]);
    s.add([startX, startX, startY - 1, -1]);

    while (s.isNotEmpty) {
      var tuple = s.removeLast();
      var x1 = tuple[0];
      var x2 = tuple[1];
      var y = tuple[2];
      var dy = tuple[3];

      var nx = x1;
      if (_isInside(nx, y, targetColor)) {
        while (_isInside(nx - 1, y, targetColor)) {
          _setColor(nx - 1, y, newColor);
          nx--;
        }
        if (nx < x1) {
          s.add([nx, x1 - 1, y - dy, -dy]);
        }
      }

      while (x1 <= x2) {
        while (_isInside(x1, y, targetColor)) {
          _setColor(x1, y, newColor);
          x1++;
        }
        if (x1 > nx) {
          s.add([nx, x1 - 1, y + dy, dy]);
        }
        if (x1 - 1 > x2) {
          s.add([x2 + 1, x1 - 1, y - dy, -dy]);
        }
        x1++;
        while (x1 < x2 && !_isInside(x1, y, targetColor)) {
          x1++;
        }
        nx = x1;
      }
    }
    return image;
  }
}
