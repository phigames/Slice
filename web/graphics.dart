part of slice;

class Graphics {

  int width, height;
  CanvasElement canvas, buffer;
  CanvasRenderingContext2D canvasContext, bufferContext;

  Graphics(this.canvas) {
    width = canvas.width;
    height = canvas.height;
    buffer = new CanvasElement(width: width, height: height);
    canvasContext = canvas.context2D;
    bufferContext = buffer.context2D;
    canvas.onMouseDown.listen(Mouse.onMouseDown);
    canvas.onMouseUp.listen(Mouse.onMouseUp);
    canvas.onMouseMove.listen(Mouse.onMouseMove);
  }

  void clear() {
    bufferContext.clearRect(0, 0, width, height);
  }

  void drawPolygon(Polygon polygon, Vector position) {
    bufferContext.beginPath();
    bufferContext.moveTo(position.x + polygon.points[0].x, position.y + polygon.points[0].y);
    for (int i = 1; i < polygon.points.length; i++) {
      bufferContext.lineTo(position.x + polygon.points[i].x, position.y + polygon.points[i].y);
    }
    bufferContext.closePath();
    bufferContext.fillStyle = polygon.color;
    bufferContext.fill();
  }

  void drawPoint(Vector point, String color) {
    bufferContext.fillStyle = color;
    bufferContext.fillRect(point.x - 1, point.y - 1, 3, 3);
  }

  void drawLine(Line line, num length, String color) {
    Vector e = line.initial + line.direction * length;
    bufferContext.beginPath();
    bufferContext.moveTo(line.initial.x, line.initial.y);
    bufferContext.lineTo(e.x, e.y);
    bufferContext.strokeStyle = color;
    bufferContext.stroke();
  }

  void flush() {
    canvasContext.clearRect(0, 0, width, height);
    canvasContext.drawImage(buffer, 0, 0);
  }

}

class Vector {

  num x, y;

  Vector(this.x, this.y) {

  }

  Vector.fromAngle(num angle, num length) {
    x = cos(angle) * length;
    y = sin(angle) * length;
  }

  operator +(Vector other) => new Vector(x + other.x, y + other.y);

  operator -(Vector other) => new Vector(x - other.x, y - other.y);

  operator *(num factor) => new Vector(x * factor, y * factor);

  operator /(num divisor) => new Vector(x / divisor, y / divisor);

  num angle() => atan(y / x);

  num length() => sqrt(x * x + y * y);

  void normalize() {
    num l = length();
    x /= l;
    y /= l;
  }

  String toString() => 'Vector($x, $y)';

}

class Line {

  Vector initial, direction;

  Line.passingThrough(Vector pointA, Vector pointB, [bool normalized = false]) {
    initial = pointA;
    direction = pointB - pointA;
    if (normalized) {
      direction.normalize();
    }
  }

  Intersection pointAt(num parameter) => new Intersection(initial + direction * parameter, parameter);

  Vector intersectionWith(Line other) {
    num p = (other.direction.y * other.initial.x - other.direction.y * initial.x + other.direction.x * initial.y - other.direction.x * other.initial.y) / (other.direction.y * direction.x - other.direction.x * direction.y);
    return pointAt(p);
  }

}

class Intersection extends Vector {

  num parameter;
  int edge;

  Intersection(Vector point, this.parameter) : super(point.x, point.y);

  operator +(Vector other) => new Intersection(this + other, parameter);

  operator -(Vector other) => new Intersection(this - other, parameter);

}

class Polygon {

  List<Vector> points;
  String color;

  Polygon() {
    ponts = new List<Vector>();
  }

  Polygon(this.points, this.color);

  num area() {
    num a = 0;
    for (int i = 1; i < points.length; i++) {
      a += (points[i].x - points[i - 1].x) * (points[i - 1].y + points[i].y) / 2;
    }
    return a.abs();
  }

  List<Polygon> split(Vector position, Line line) {
    List<Vector> _points;
    List<Intersection> _intersections;
    for (int i = 0; i < points.length; i++) {
      _points.add(points[i]);
      Vector p1, p2;
      if (i == points.length - 1) {
        p1 = position + points[i];
        p2 = position + points[0];
      } else {
        p1 = position + points[i];
        p2 = position + points[i + 1];
      }
      Intersection p = line.intersectionWith(new Line.passingThrough(p1, p2)) - position;
      if ((p.x - p1.x).sign == -(p.x - p2.x).sign) {
        _points.add(p);
        _intersections.add(p);
      }
    }
    _intersections.sort((a, b) => a.parameter.compareTo(b.parameter));
    List<List<Intersection>> _intersectionPairs;
    for (int i = 0; i < _intersections.length; i += 2) {
      _intersectionPairs.add([ _intersections[i], _intersections[i + 1]]);
    }
    List<Polygon> _outputs;
    List<Vector> _crossbacks;
    int _current;
    _outputs.add(new Polygon());
    _current = 0;
    for (int i = 0; i < _points.length; i++) {
      _current.points.add(_points[i]);
      if (_intersections.contains(_points[i])) {
        for (int j = 0; j < _intersectionPairs.length; j++) {

        }
      }
    }
  }

}