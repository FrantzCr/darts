import 'dart:math';
import 'package:flutter/painting.dart';

const List<int> kSectorOrder = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];

class BoardRadii {
  static const double outer = 190;
  static const double doubleO = 170;
  static const double doubleI = 160;
  static const double tripleO = 105;
  static const double tripleI = 95;
  static const double outerBull = 16;
  static const double bull = 7;
}

Offset polar(double r, double degrees) {
  final rad = degrees * pi / 180;
  return Offset(r * cos(rad), r * sin(rad));
}

({double a1, double a2, double center}) sectorAngles(int index) {
  final center = -90.0 + index * 18;
  return (a1: center - 9, a2: center + 9, center: center);
}
