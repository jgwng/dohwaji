import 'dart:async';

abstract class FloodFill<T,S>{
  final T image;
  const FloodFill(this.image);
  FutureOr<T?> fill(int startX, int startY, S newColor);
}