class Bar {
  final int t; // seconds, UTC
  final double o, h, l, c;
  Bar(this.t, this.o, this.h, this.l, this.c);
}

class Cfg {
  double riskPct = 1, slDist = 0.002, rr = 2, beR = 1;
  bool costs = true, autoBE = true;
}

class Pos {
  final bool long;
  final double entry, d, risk;
  double sl, tp, units, realized = 0;
  bool be = false;
  final int time;
  Pos(this.long, this.entry, this.sl, this.tp, this.d, this.units, this.risk, this.time);
  int get dir => long ? 1 : -1;
}

class Trade {
  final int id, time;
  final bool long, amb;
  final double pnl, r;
  String? emotion, mistake, grade;
  Trade(this.id, this.long, this.pnl, this.r, this.amb, this.time);
}

class Sim {
  int idx;
  double balance;
  Pos? pos;
  List<Trade> trades = [];
  List<Trade> base; // trades from earlier sessions on the same account
  Sim(this.idx, this.balance, this.base);
}

class Stats {
  int n = 0;
  double win = 0, pf = 0, exp = 0, dd = 0;
}
