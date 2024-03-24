import 'package:dohwaji/ui/flood_fill/flood_fill_interface.dart';

class BasicFloodFill extends FloodFill<List<List<int>>, int> {
  const BasicFloodFill(List<List<int>> image) : super(image);

  @override
  List<List<int>>? fill(int startX, int startY, int newColor) {
    int originalColor = image[startX][startY];
    _floodFillUtil(startX, startY, originalColor, newColor);
    return image;
  }

  void _floodFillUtil(int x, int y, int originalColor, int newColor) {
    // Check if current node is inside the boundary and not already filled
    if (!_isInside(x, y) || image[x][y] != originalColor) return;

    // Set the node
    image[x][y] = newColor;

    // Perform flood-fill one step in each direction
    _floodFillUtil(x + 1, y, originalColor, newColor); // South
    _floodFillUtil(x - 1, y, originalColor, newColor); // North
    _floodFillUtil(x, y - 1, originalColor, newColor); // West
    _floodFillUtil(x, y + 1, originalColor, newColor); // East
  }

  bool _isInside(int x, int y) {
    return x >= 0 && x < image.length && y >= 0 && y < image[0].length;
  }
}
