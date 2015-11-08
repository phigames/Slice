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

  void drawPolygon(Polygon polygon, Vector position, String color) {
    bufferContext.beginPath();
    bufferContext.moveTo(position.x + polygon.points[0].x, position.y + polygon.points[0].y);
    for (int i = 1; i < polygon.points.length; i++) {
      bufferContext.lineTo(position.x + polygon.points[i].x, position.y + polygon.points[i].y);
    }
    bufferContext.closePath();
    bufferContext.fillStyle = color;
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

  Vector(this.x, this.y);

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

  Vector copy() {
    return new Vector(this.x, this.y);
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

  operator +(Vector other) => new Intersection(new Vector(x + other.x, y + other.y), parameter);

  operator -(Vector other) => new Intersection(new Vector(x - other.x, y - other.y), parameter);

}

class Polygon {

  List<Vector> points;

  Polygon(this.points);

  Polygon.empty() {
    points = new List<Vector>();
  }

  num area() {
    num a = 0;
    for (int i = 1; i < points.length; i++) {
      a += (points[i].x - points[i - 1].x) * (points[i - 1].y + points[i].y) / 2;
    }
    return a.abs();
  }

  List<Polygon> split(Vector position, Line line) {
    List<Vector> _points = new List<Vector>();
    List<Intersection> _intersections = new List<Intersection>();
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
      Intersection p = line.intersectionWith(new Line.passingThrough(p1, p2));
      if ((p.x - p1.x).sign == -(p.x - p2.x).sign) {
        Intersection pp = p - position;
        _points.add(pp);
        _intersections.add(pp);
      }
    }
    if (_intersections.length == 0) {
      return null;
    }
    _intersections.sort((a, b) => a.parameter.compareTo(b.parameter));
    List<List<Intersection>> _intersectionPairs = new List<List<Intersection>>();
    for (int i = 0; i < _intersections.length; i += 2) {
      _intersectionPairs.add([ _intersections[i], _intersections[i + 1]]);
    }
    List<Polygon> _outputs = new List<Polygon>();
    List<Vector> _crossbacks = new List<Vector>();
    int _current;
    _outputs.add(new Polygon.empty());
    _crossbacks.add(null);
    _current = 0;
    for (int i = 0; i < _points.length; i++) {
      _outputs[_current].points.add(_points[i]);
      if (_intersections.contains(_points[i])) {
        for (int j = 0; j < _intersectionPairs.length; j++) {
          int _partnerIndex = 1 - _intersectionPairs[j].indexOf(_points[i]);
          if (_partnerIndex != 2) {
            _crossbacks[_current] = _intersectionPairs[j][_partnerIndex];
            break;
          }
        }
        int _crossbackIndex = _crossbacks.indexOf(_points[i]);
        if (_crossbackIndex != -1) {
          _current = _crossbackIndex;
        } else {
          _outputs.add(new Polygon.empty());
          _crossbacks.add(_points[i]); // necessary? null?
          _current = _outputs.length - 1;
        }
        _outputs[_current].points.add(_points[i]);
      }
    }
    return _outputs;
  }

}