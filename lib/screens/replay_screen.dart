import 'dart:async';
import 'package:flutter/material.dart';
import '../data/market_data.dart';
import '../data/plans.dart';
import '../engine/constants.dart';
import '../engine/engine.dart';
import '../engine/models.dart';
import '../theme/app_theme.dart';
import '../widgets/chart_painter.dart';
import '../widgets/control_bar.dart';
import '../widgets/journal_list.dart';
import '../widgets/section_card.dart';
import '../widgets/settings_panel.dart';
import '../widgets/stats_panel.dart';

class ReplayScreen extends StatefulWidget {
  final String user;
  final Plan plan;
  final VoidCallback onPlans, onSignOut;
  const ReplayScreen({
    super.key,
    required this.user,
    required this.plan,
    required this.onPlans,
    required this.onSignOut,
  });
  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  final cfg = Cfg();
  Sim s = Sim(randIdx(), startBalance, []);
  Timer? timer;
  int speed = 10;
  int settingsKey = 0; // forces the number fields to rebuild on a new session
  final fields = {'emotion': true, 'mistake': true, 'grade': true};

  void upd(void Function() f) => setState(f);
  void tick() => upd(() => step(s, bars, cfg));

  void _startTimer() => timer = Timer.periodic(
    Duration(milliseconds: 1000 ~/ speed),
    (_) => tick(),
  );

  void toggle() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    } else {
      _startTimer();
    }
    setState(() {});
  }

  void setSpeed(int v) {
    speed = v;
    if (timer != null) {
      timer!.cancel();
      _startTimer();
    }
    setState(() {});
  }

  void newSession(bool fresh) {
    timer?.cancel();
    timer = null;
    final base = fresh ? <Trade>[] : [...s.base, ...s.trades];
    upd(() => s = Sim(randIdx(), fresh ? startBalance : s.balance, base));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = s.pos, b = bars[s.idx];
    final List<(double, Color)> lines = p == null
        ? <(double, Color)>[]
        : [
            (p.entry, Colors.grey),
            (p.sl, AppColors.down),
            (p.tp, AppColors.up),
          ];
    final sessStart = s.balance - s.trades.fold<double>(0, (a, t) => a + t.pnl);
    final clock = DateTime.fromMillisecondsSinceEpoch(
      b.t * 1000,
      isUtc: true,
    ).toString().substring(0, 16);
    final chart = CustomPaint(
      size: Size.infinite,
      painter: ChartPainter(bars.sublist(s.idx - 99, s.idx + 1), lines),
    );
    final controls = ControlBar(
      playing: timer != null,
      hasPos: p != null,
      speed: speed,
      balance: s.balance.toStringAsFixed(2),
      clock: clock,
      onToggle: toggle,
      onStep: tick,
      onSkip: () => upd(() {
        for (var i = 0; i < 1440; i++) {
          step(s, bars, cfg);
        }
      }),
      onSpeed: setSpeed,
      onBuy: () => upd(() => openPos(s, true, b, cfg)),
      onSell: () => upd(() => openPos(s, false, b, cfg)),
      onPartial: () => upd(() => partialClose(s, b, cfg)),
    );
    final panels = <Widget>[
      if (p != null)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${p.long ? "buy" : "sell"} ${(p.units / lot).toStringAsFixed(2)} lots · SL ${p.sl.toStringAsFixed(5)} · TP ${p.tp.toStringAsFixed(5)}${p.be ? " · BE" : ""}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      SectionCard(
        title: 'Settings',
        child: SettingsPanel(
          key: ValueKey(settingsKey),
          cfg: cfg,
          onChanged: () => upd(() {}),
          onNewSession: () => newSession(false),
          onReset: () => newSession(true),
        ),
      ),
      SectionCard(
        title: 'Stats',
        child: StatsPanel(
          session: s.trades,
          all: [...s.base, ...s.trades],
          sessionStart: sessStart,
          accountStart: startBalance,
        ),
      ),
      SectionCard(
        title: 'Journal',
        child: JournalList(
          trades: s.trades,
          fields: fields,
          onChanged: () => upd(() {}),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 12),
        child: Text(
          'Simulated results. Hypothetical performance; not investment advice.',
          style: TextStyle(fontSize: 11, color: Colors.white38),
        ),
      ),
    ];
    Widget spaced(List<Widget> w) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < w.length; i++) ...[
          if (i > 0 && w[i] is! Padding) const SizedBox(height: 8),
          w[i],
        ],
      ],
    );
    final header = _Header(
      user: widget.user,
      plan: widget.plan,
      onPlans: widget.onPlans,
      onSignOut: widget.onSignOut,
    );
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            if (c.maxWidth >= wideBreakpoint) {
              // Web / tablet: chart + controls on the left, scrolling side panel on the right.
              return Column(
                children: [
                  header,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(child: chart),
                                controls,
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 380,
                            child: SingleChildScrollView(child: spaced(panels)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            // Phone: one scrolling column.
            final chartH = (c.maxHeight * 0.42).clamp(240.0, 380.0);
            return ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: [
                header,
                SizedBox(height: chartH, child: chart),
                controls,
                const SizedBox(height: 4),
                spaced(panels),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String user;
  final Plan plan;
  final VoidCallback onPlans, onSignOut;
  const _Header({
    required this.user,
    required this.plan,
    required this.onPlans,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.candlestick_chart, color: AppColors.accent, size: 22),
        const SizedBox(width: 8),
        const Text(
          'Replay Trader',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const Spacer(),
        ActionChip(
          label: Text(plan.name, style: const TextStyle(fontSize: 12)),
          visualDensity: VisualDensity.compact,
          onPressed: onPlans,
        ),
        PopupMenuButton<String>(
          tooltip: 'Account',
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (v) => v == 'plans' ? onPlans() : onSignOut(),
          itemBuilder: (_) => [
            PopupMenuItem(
              enabled: false,
              child: Text(user, style: const TextStyle(fontSize: 12)),
            ),
            const PopupMenuItem(value: 'plans', child: Text('Plans')),
            const PopupMenuItem(value: 'out', child: Text('Sign out')),
          ],
        ),
      ],
    ),
  );
}
