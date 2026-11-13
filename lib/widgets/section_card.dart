import 'package:flutter/material.dart';

/// Compact titled card used for the settings, stats and journal blocks.
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w700, color: Colors.white54)),
            const SizedBox(height: 8),
            child,
          ]),
        ),
      );
}
