import 'dart:math';
import 'package:flutter/material.dart';
import '../engine/models.dart';
import '../theme/app_theme.dart';

class ChartPainter extends CustomPainter {
  final List<Bar> v; // only bars at or before the clock
  final List<(double, Color)> lines;
  ChartPainter(this.v, this.lines);

  @override
  void paint(Canvas cv, Size s) {
    var hi = v.map((b) => b.h).reduce(max), lo = v.map((b) => b.l).reduce(min);
    for (final l in lines) {
      hi = max(hi, l.$1);
      lo = min(lo, l.$1);
    }
    double y(double p) => s.height * (1 - (p - lo) / (hi - lo));
    final w = s.width / v.length;
    for (var k = 0; k < v.length; k++) {
      final b = v[k], x = k * w + w / 2;
      final col = Paint()
        ..color = b.c >= b.o ? AppColors.up : AppColors.down
        ..strokeWidth = 1;
      cv.drawLine(Offset(x, y(b.h)), Offset(x, y(b.l)), col);
      cv.drawRect(Rect.fromLTRB(x - w * .35, y(max(b.o, b.c)), x + w * .35, y(min(b.o, b.c)) + .5), col);
    }
    for (final l in lines) {
      cv.drawLine(Offset(0, y(l.$1)), Offset(s.width, y(l.$1)), Paint()..color = l.$2..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
