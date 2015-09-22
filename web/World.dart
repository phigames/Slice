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
    List<Vector> ps = new List<Vector>();
    for (int i = 0; i < polygon.points.length; i++) {
      ps.add(polygon.points[i]);
      Vector p1, p2;
      if (i == polygon.points.length - 1) {
        p1 = position + polygon.points[i];
        p2 = position + polygon.points[0];
      } else {
        p1 = position + polygon.points[i];
        p2 = position + polygon.points[i + 1];
      }
      Vector p = line.intersectionWith(new Line.passingThrough(p1, p2));
      if ((p.x - p1.x).sign == -(p.x - p2.x).sign) {
        ps.add((p - position)..tag = 'intersection');
      }
    }
    if (ps.length > polygon.points.length) {
      List<Thing> ts = separate(ps, 0);
      for (int i = 0; i < ts.length; i++) {
        for (int j = 0; j < ts[i].polygon.points.length; j++) {
          ts[i].polygon.points[j].tag = null;
        }
      }
      return ts;
    } else {
      return null;
    }
  }

  List<Thing> separate(List<Vector> points, int start) {
    List<Thing> ts = new List<Thing>();
    List<int> ss = new List<int>();
    Thing t = new Thing()..position = position;
    int i = start;
    while (true) {
      if (points[i].tag == 'intersection') {
        t.polygon.points.add(points[i]);
        int s = i + 1;
        if (s == points.length) {
          s = 0;
        }
        ss.add(s);
        int j = i;
        do {
          j++;
          if (j == points.length) {
            j = 0;
          }
        } while (points[j].tag != 'intersection');
        i = j;
        t.polygon.points.add(points[i]);
      } else {
        t.polygon.points.add(points[i]..tag = 'used');
      }
      i++;
      if (i == points.length) {
        i = 0;
      }
      if (i == start) {
        ts.add(t);
        for (int j = 0; j < ss.length; j++) {
          if (points[ss[j]].tag != 'used') {
            ts.addAll(separate(points, ss[j]));
          }
        }
        print('separate: ' + ts.length.toString());
        return ts;
      }
    }
  }

  void draw() {
    graphics.drawPolygon(polygon, position);
  }

}