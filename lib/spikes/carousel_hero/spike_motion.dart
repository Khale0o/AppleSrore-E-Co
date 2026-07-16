import 'dart:math' as math;

import 'package:flutter/material.dart';

abstract final class SpikeMotion {
  static const fast = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 280);
  static const emphasis = Duration(milliseconds: 420);
  static const hero = Duration(milliseconds: 600);

  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;

  static double clamp(double value) => value.clamp(-1.0, 1.0);
  static double degrees(double value) => value * math.pi / 180;
}
