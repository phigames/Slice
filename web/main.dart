library slice;

import 'dart:html';
import 'dart:math';

part 'world.dart';
part 'input.dart';
part 'graphics.dart';

Graphics graphics;
Random random;
num updateTime;
World world;
/*Polygon testPolygon;
Line testLine;
List<Vector> intersections;*/

void main() {
  Mouse.init();
  graphics = new Graphics(querySelector('#canvas'));
  random = new Random();
  updateTime = -1;
  world = new World();
  requestFrame();
}

void frame(num time) {
  if (updateTime == -1) {
    updateTime = time;
  } else {
    world.update();
    graphics.clear();
    world.draw();
    graphics.flush();
    updateTime = time;
  }
  requestFrame();
}

void requestFrame() {
  window.animationFrame.then(frame);
}
