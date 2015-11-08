part of slice;

class World {

  List<Thing> things;
  bool dragging;
  num draggingX, draggingY;
  Line draggingLine;

  World() {
    things = new List<Thing>();
    things.add(new Thing.random(new Vector(100, 100)));
    dragging = false;
  }

  void draw() {
    for (int i = 0; i < things.length; i++) {
      things[i].draw();
    }
    if (!dragging) {
      if (Mouse.left) {
        dragging = true;
        draggingX = Mouse.x;
        draggingY = Mouse.y;
        draggingLine = new Line.passingThrough(new Vector(draggingX, draggingY), new Vector(Mouse.x, Mouse.y));
      }
    } else {
      if (!Mouse.left) {
        dragging = false;
        for(int i = 0; i < things.length; i++) {
          List<Thing> ts = things[i].slice(draggingLine);
          if (ts != null) {
            things.removeAt(i);
            i--;
            print(ts.length);
            for (int j = 0; j < ts.length; j++) {
              things.add(ts[j]);
              i++;
            }
          }
        }
      } else {
        draggingLine = new Line.passingThrough(new Vector(draggingX, draggingY), new Vector(Mouse.x, Mouse.y));
      }
    }
    if (dragging) {
      graphics.drawLine(draggingLine, 2, '#000');
    }
  }

}

class Thing {

  Vector position;
  Polygon polygon;

  Thing() {
    polygon = new Polygon(new List<Vector>(), '#' + (random.nextInt(0xF00) + 0x100).toRadixString(16));
  }

  Thing.random(this.position) {
    List<Vector> p = new List<Vector>();
    for (int i = 0; i < 7; i++) {
      p.add(new Vector.fromAngle(PI * 2 * i / 7, random.nextDouble() * 30 + 10));
    }
    polygon = new Polygon(p, '#' + (random.nextInt(0xF00) + 0x100).toRadixString(16));
    print(polygon.area());
  }

  List<Thing> slice(Line line) {

  }

  void draw() {
    graphics.drawPolygon(polygon, position);
  }

}
