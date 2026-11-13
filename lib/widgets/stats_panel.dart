import 'package:flutter/material.dart';
import '../engine/engine.dart';
import '../engine/models.dart';

class StatsPanel extends StatelessWidget {
  final List<Trade> session, all;
  final double sessionStart, accountStart;
  const StatsPanel({super.key, required this.session, required this.all, required this.sessionStart, required this.accountStart});

  String _f2(double v) => v.toStringAsFixed(2);
  String _row(String a, Stats st) =>
      '$a: ${st.n} trades · win ${(st.win * 100).toStringAsFixed(0)}% · PF ${st.pf.isInfinite ? "∞" : _f2(st.pf)} · exp ${_f2(st.exp)}R · maxDD ${(st.dd * 100).toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_row('Session', calc(session, sessionStart))),
        Text(_row('Account', calc(all, accountStart))),
        Text(sessionStats(all), style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ]);
}
