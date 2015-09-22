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
  String tag;

  Vector(this.x, this.y) {
    tag = null;
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

  Vector pointAt(num parameter) => initial + direction * parameter;

  Vector intersectionWith(Line other) {
    num p = (direction.y * initial.x - direction.y * other.initial.x + direction.x * other.initial.y - direction.x * initial.y) / (direction.y * other.direction.x - direction.x * other.direction.y);
    return other.pointAt(p);
  }

}

class Polygon {

  List<Vector> points;
  String color;

  Polygon(this.points, this.color);

  num area() {
    num a = 0;
    for (int i = 1; i < points.length; i++) {
      a += (points[i].x - points[i - 1].x) * (points[i - 1].y + points[i].y) / 2;
    }
    return a.abs();
  }

}