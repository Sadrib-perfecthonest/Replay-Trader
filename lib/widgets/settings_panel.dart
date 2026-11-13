import 'package:flutter/material.dart';
import '../engine/models.dart';

class SettingsPanel extends StatelessWidget {
  final Cfg cfg;
  final VoidCallback onChanged, onNewSession, onReset;

  const SettingsPanel({super.key, required this.cfg, required this.onChanged, required this.onNewSession, required this.onReset});

  Widget _field(String label, double v, void Function(double) set) => SizedBox(
        width: 96,
        child: TextFormField(
          initialValue: '$v',
          decoration: InputDecoration(labelText: label, isDense: true),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (x) => set(double.tryParse(x) ?? v),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 10, children: [
          _field('Risk %', cfg.riskPct, (v) => cfg.riskPct = v),
          _field('SL (price)', cfg.slDist, (v) => cfg.slDist = v),
          _field('Reward:risk', cfg.rr, (v) => cfg.rr = v),
          _field('BE at R', cfg.beR, (v) => cfg.beR = v),
        ]),
        SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Costs (spread, commission)'),
            value: cfg.costs,
            onChanged: (v) {
              cfg.costs = v;
              onChanged();
            }),
        SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Auto break-even'),
            value: cfg.autoBE,
            onChanged: (v) {
              cfg.autoBE = v;
              onChanged();
            }),
        Wrap(spacing: 6, runSpacing: 6, children: [
          ElevatedButton(onPressed: onNewSession, child: const Text('New session (keep balance)')),
          ElevatedButton(onPressed: onReset, child: const Text('Reset account')),
        ]),
      ]);
}
