part of slice;

class Mouse {

  static bool left;
  static int x, y;

  static void init() {
    left = false;
  }

  static void onMouseDown(MouseEvent event) {
    if (event.button == 0) {
      left = true;
    }
  }

  static void onMouseUp(MouseEvent event) {
    if (event.button == 0) {
      left = false;
    }
  }

  static void onMouseMove(MouseEvent event) {
    x = event.layer.x;
    y = event.layer.y;
  }

}