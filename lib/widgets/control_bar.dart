import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ControlBar extends StatelessWidget {
  final bool playing, hasPos;
  final int speed;
  final String balance, clock;
  final VoidCallback onToggle, onStep, onSkip, onBuy, onSell, onPartial;
  final ValueChanged<int> onSpeed;

  const ControlBar({
    super.key,
    required this.playing,
    required this.hasPos,
    required this.speed,
    required this.balance,
    required this.clock,
    required this.onToggle,
    required this.onStep,
    required this.onSkip,
    required this.onBuy,
    required this.onSell,
    required this.onPartial,
    required this.onSpeed,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text('\$$balance', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('$clock UTC', style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ]),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            ElevatedButton(onPressed: onToggle, child: Text(playing ? 'Pause' : 'Play')),
            ElevatedButton(onPressed: onStep, child: const Text('Step')),
            ElevatedButton(onPressed: onSkip, child: const Text('Skip day')),
            DropdownButton<int>(
              value: speed,
              isDense: true,
              underline: const SizedBox.shrink(),
              items: [1, 2, 5, 10, 30, 60].map((v) => DropdownMenuItem(value: v, child: Text('$v/s'))).toList(),
              onChanged: (v) => onSpeed(v!),
            ),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.buy), onPressed: onBuy, child: const Text('Buy'))),
            const SizedBox(width: 6),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.sell), onPressed: onSell, child: const Text('Sell'))),
            const SizedBox(width: 6),
            Expanded(child: ElevatedButton(onPressed: hasPos ? onPartial : null, child: const Text('Close 50%'))),
          ]),
        ]),
      );
}
