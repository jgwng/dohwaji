abstract class FloodFill{
  final List<List<int>> image;
  const FloodFill(this.image);
  void fill(int startX, int startY, int newColor);
}