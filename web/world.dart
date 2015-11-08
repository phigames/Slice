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

  void update() {
    for (int i = 0; i < things.length; i++) {
      if (random.nextInt(5) == 0) {
        things[i].position.x += random.nextInt(2) * 2 - 1;
        things[i].position.y += random.nextInt(2) * 2 - 1;
      }
    }
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
        List<Thing> _newThings = new List<Thing>();
        for (int i = 0; i < things.length; i++) {
          List<Thing> ts = things[i].slice(draggingLine);
          if (ts != null) {
            things.removeAt(i);
            i--;
            for (int j = 0; j < ts.length; j++) {
              _newThings.add(ts[j]);
            }
          }
        }
        for (int i = 0; i < _newThings.length; i++) {
          things.add(_newThings[i]);
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

  Polygon polygon;
  Vector position;
  String color;

  Thing.random(this.position) {
    List<Vector> p = new List<Vector>();
    for (int i = 0; i < 7; i++) {
      p.add(new Vector.fromAngle(PI * 2 * i / 7, random.nextDouble() * 30 + 10));
    }
    polygon = new Polygon(p);
    color = '#' + (random.nextInt(0xF00) + 0x100).toRadixString(16);
  }

  Thing.fromPolygon(this.position, this.polygon, this.color);

  List<Thing> slice(Line line) {
    List<Polygon> _polygons = polygon.split(position, line);
    if (_polygons != null) {
      List<Thing> _outputs = new List<Thing>();
      for (int i = 0; i < _polygons.length; i++) {
        _outputs.add(new Thing.fromPolygon(position.copy(), _polygons[i], '#' + (random.nextInt(0xF00) + 0x100).toRadixString(16)));
      }
      return _outputs;
    } else {
      return null;
    }
  }

  void draw() {
    graphics.drawPolygon(polygon, position, color);
  }

}
