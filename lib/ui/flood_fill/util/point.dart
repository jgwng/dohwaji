import 'dart:collection';

import 'package:dohwaji/ui/flood_fill/util/flood_fill_interface.dart';

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);
}

class FloodFillQueueImpl extends FloodFill<List<List<int>>, int> {
  const FloodFillQueueImpl(List<List<int>> image) : super(image);

  @override
  List<List<int>>? fill(int startX, int startY, int newColor) {
    final int oldColor = image[startX][startY];
    final int width = image[0].length;
    final int height = image.length;
    final Queue<Point> queue = Queue();
    queue.add(Point(startY, startX));

    while (queue.isNotEmpty) {
      final Point point = queue.removeFirst();
      final int x = point.x;
      final int y = point.y;

      if (image[y][x] == oldColor) {
        image[y][x] = newColor;

        if (x > 0) {
          queue.add(Point(x - 1, y));
        }
        if (x < width - 1) {
          queue.add(Point(x + 1, y));
        }
        if (y > 0) {
          queue.add(Point(x, y - 1));
        }
        if (y < height - 1) {
          queue.add(Point(x, y + 1));
        }
      }
    }
    return image;
  }
}
