import 'dart:math';
import 'constants.dart';
import 'models.dart';

double _half(Cfg c) => c.costs ? spread / 2 : 0;

// Position size = risk money / stop distance ($100k, 1%, 20 pips => 5 lots).
void openPos(Sim s, bool long, Bar b, Cfg c) {
  if (s.pos != null) return;
  final dir = long ? 1 : -1, entry = b.c + dir * _half(c), d = c.slDist, risk = s.balance * c.riskPct / 100;
  s.pos = Pos(long, entry, entry - dir * d, entry + dir * d * c.rr, d, risk / d, risk, b.t);
}

void realize(Sim s, double price, double units, Cfg c, {bool amb = false}) {
  final p = s.pos!, comm = c.costs ? commPerLot * units / lot * 2 : 0;
  final pnl = p.dir * (price - p.entry) * units - comm;
  s.balance += pnl;
  p.realized += pnl;
  p.units -= units;
  if (p.units > 1e-6) return;
  s.trades.add(Trade(s.base.length + s.trades.length + 1, p.long, p.realized, p.realized / p.risk, amb, p.time));
  s.pos = null;
}

void partialClose(Sim s, Bar b, Cfg c) {
  final p = s.pos;
  if (p != null) realize(s, b.c - p.dir * _half(c), p.units * .5, c);
}

// One base-bar step. Stop and target in the same bar => stop fills first, flagged ambiguous.
void step(Sim s, List<Bar> bars, Cfg c) {
  if (s.idx >= bars.length - 1) return;
  final b = bars[++s.idx], p = s.pos;
  if (p == null) return;
  final h = _half(c);
  final hitSL = p.dir > 0 ? b.l - h <= p.sl : b.h + h >= p.sl;
  final hitTP = p.dir > 0 ? b.h - h >= p.tp : b.l + h <= p.tp;
  if (hitSL || hitTP) return realize(s, hitSL ? p.sl : p.tp, p.units, c, amb: hitSL && hitTP);
  final fav = p.dir > 0 ? b.h - h - p.entry : p.entry - b.l - h;
  if (c.autoBE && !p.be && fav >= p.d * c.beR) {
    p.sl = p.entry;
    p.be = true;
  }
}

Stats calc(List<Trade> ts, double start) {
  final st = Stats()..n = ts.length;
  if (ts.isEmpty) return st;
  double gp = 0, gl = 0, bal = start, peak = start, rs = 0;
  int w = 0;
  for (final t in ts) {
    if (t.pnl > 0) {
      w++;
      gp += t.pnl;
    } else if (t.pnl < 0) {
      gl -= t.pnl;
    }
    bal += t.pnl;
    peak = max(peak, bal);
    st.dd = max(st.dd, (peak - bal) / peak);
    rs += t.r;
  }
  st.win = w / ts.length;
  st.pf = gl > 0 ? gp / gl : (gp > 0 ? double.infinity : 0);
  st.exp = rs / ts.length;
  return st;
}

String sessionStats(List<Trade> ts) {
  const sess = {'Asia': [0, 9], 'London': [8, 17], 'New York': [13, 22]}; // GMT, editable later
  return sess.entries.map((e) {
    final x = ts.where((t) {
      final h = DateTime.fromMillisecondsSinceEpoch(t.time * 1000, isUtc: true).hour;
      return h >= e.value[0] && h < e.value[1];
    }).toList();
    final avg = x.isEmpty ? 0 : x.map((t) => t.r).reduce((a, b) => a + b) / x.length;
    return '${e.key}: ${x.length} trades, ${avg.toStringAsFixed(2)}R';
  }).join('\n');
}
