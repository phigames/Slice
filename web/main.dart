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
  /*testPolygon = new Polygon([new Vector(50, 50), new Vector(120, 80), new Vector(80, 110)], '#F00');
  testLine = new Line.passingThrough(new Vector(50, 80), new Vector(120, 100), true);
  intersections = new List<Vector>();
  for (int i = 0; i < testPolygon.points.length; i++) {
    Vector p1, p2;
    if (i == 0) {
      p1 = testPolygon.points[testPolygon.points.length - 1];
      p2 = testPolygon.points[0];
    } else {
      p1 = testPolygon.points[i - 1];
      p2 = testPolygon.points[i];
    }
    Vector p = testLine.intersectionWith(new Line.passingThrough(p1, p2));
    if ((p.x - p1.x).sign != (p.x - p2.x).sign) {
      intersections.add(p);
    }
  }*/
  requestFrame();
}

void frame(num time) {
  if (updateTime == -1) {
    updateTime = time;
  } else {
    graphics.clear();
    world.draw();
    /*graphics.drawPolygon(testPolygon);
    graphics.drawLine(testLine, 300, '#000');
    for (int i = 0; i < intersections.length; i++) {
      graphics.drawPoint(intersections[i], '#0F0');
    }*/
    graphics.flush();
    updateTime = time;
  }
  requestFrame();
}

void requestFrame() {
  window.animationFrame.then(frame);
}
