import 'dart:math';
import '../engine/models.dart';

// Placeholder data. Real data = licensed vendor -> chunk files on a CDN (guide s12).
List<Bar> genBars(int n) {
  final r = Random(7);
  double p = 1.085;
  int t = 1710201600; // 2024-03-12 00:00 UTC
  return List.generate(n, (_) {
    final o = p, c = o + (r.nextDouble() - .5) * .0008;
    p = c;
    t += 60;
    return Bar(t, o, max(o, c) + r.nextDouble() * .0003, min(o, c) - r.nextDouble() * .0003, c);
  });
}

final List<Bar> bars = genBars(20000);

int randIdx() => 300 + Random().nextInt(bars.length - 3000);
