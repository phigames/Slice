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
  }

  void clear() {
    bufferContext.clearRect(0, 0, width, height);
  }

  void draw(Polygon polygon) {
    bufferContext.beginPath();
    bufferContext.moveTo(polygon.points[0].x, polygon.points[0].y);
    for (int i = 1; i < polygon.points.length; i++) {
      bufferContext.lineTo(polygon.points[i].x, polygon.points[i].y);
    }
    bufferContext.closePath();
    bufferContext.fillStyle = polygon.color;
    bufferContext.fill();
  }

  void flush() {
    canvasContext.clearRect(0, 0, width, height);
    canvasContext.drawImage(buffer, 0, 0);
  }

}

class Vector {

  num x, y;

  Vector(this.x, this.y);

  operator +(Vector other) => new Vector(x + other.x, y + other.y);

  operator -(Vector other) => new Vector(x - other.x, y - other.y);

  operator *(num factor) => new Vector(x * factor, y * factor);

  operator /(num divisor) => new Vector(x / divisor, y / divisor);

  num length() => sqrt(x * x + y * y);

  void normalize() {
    num l = length();
    x /= l;
    y /= l;
  }

  String toString() => '($x, $y)';

}

class Line {

  Vector initial, direction;

  Line.passingThrough(Vector pointA, Vector pointB) {
    initial = pointA;
    direction = pointB - pointA;
    direction.normalize();
  }

  Vector pointAt(num parameter) => initial + direction * parameter;

  Vector intersectionWith(Line other) {
    num p = (direction.y * initial.x - direction.y * other.initial.x + direction.x * other.initial.y - direction.x * initial.y) / (direction.y * other.direction.x - direction.x * other.direction.y);
    return other.pointAt(p);
  }

}

class Polygon {

  List<Point<num>> points;
  String color;

  Polygon(this.points, this.color);

}