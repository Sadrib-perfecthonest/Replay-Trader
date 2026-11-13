import 'package:flutter/material.dart';
import '../engine/models.dart';
import '../theme/app_theme.dart';

class JournalList extends StatelessWidget {
  final List<Trade> trades;
  final Map<String, bool> fields; // each journal field can be switched on or off
  final VoidCallback onChanged;
  const JournalList({super.key, required this.trades, required this.fields, required this.onChanged});

  Widget _drop(String hint, String? val, List<String> opts, void Function(String?) set) => DropdownButton<String>(
        value: val,
        hint: Text(hint, style: const TextStyle(fontSize: 11)),
        isDense: true,
        items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
        onChanged: (v) {
          set(v);
          onChanged();
        },
      );

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
            spacing: 8,
            children: fields.keys
                .map((k) => FilterChip(
                    label: Text(k),
                    selected: fields[k]!,
                    onSelected: (v) {
                      fields[k] = v;
                      onChanged();
                    }))
                .toList()),
        if (trades.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('No trades yet.', style: TextStyle(color: Colors.white38, fontSize: 12))),
        for (final t in trades.reversed)
          Wrap(spacing: 6, runSpacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text('#${t.id} ${t.long ? "buy" : "sell"} ${t.r.toStringAsFixed(2)}R (${t.pnl.toStringAsFixed(2)})${t.amb ? " ⚠" : ""}',
                style: TextStyle(color: t.pnl >= 0 ? AppColors.up : AppColors.down)),
            if (fields['emotion']!) _drop('emotion', t.emotion, ['calm', 'FOMO', 'revenge', 'fear', 'greedy'], (v) => t.emotion = v),
            if (fields['mistake']!) _drop('mistake', t.mistake, ['none', 'early entry', 'moved SL', 'oversized', 'no plan'], (v) => t.mistake = v),
            if (fields['grade']!) _drop('grade', t.grade, ['A', 'B', 'C'], (v) => t.grade = v),
          ]),
      ]);
}
