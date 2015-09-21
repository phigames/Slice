library slice;

import 'dart:html';
import 'dart:math';

part 'graphics.dart';

Graphics graphics;
num updateTime;

void main() {
  graphics = new Graphics(querySelector('#canvas'));
  updateTime = -1;
  requestFrame();
}

void frame(num time) {
  if (updateTime == -1) {
    updateTime = time;
  } else {
    graphics.clear();

    graphics.flush();
    updateTime = time;
  }
  requestFrame();
}

void requestFrame() {
  window.animationFrame.then(frame);
}
