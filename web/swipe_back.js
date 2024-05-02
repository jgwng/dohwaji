function handleTouchMove(event, xStart, yStart) {
  var xDiff = xStart - event.touches[0].pageX;
  var yDiff = yStart - event.touches[0].pageY;
  // Prevent horizontal swipe
  if (xDiff > 100 && Math.abs(xDiff) > Math.abs(yDiff)) {
    event.preventDefault();
  }
}

var newHandleTouchMove = function (xStart, yStart) {
  return function (event) {
    handleTouchMove(event, xStart, yStart);
  };
}
document.addEventListener('touchstart', function (startEvent) {
// Ignore multi-touch gestures
 if (startEvent.touches.length > 1) { return; } startEvent.preventDefault(); },
  { passive: false });;