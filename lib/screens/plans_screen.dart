import 'package:flutter/material.dart';
import '../data/plans.dart';
import '../theme/app_theme.dart';

class PlansScreen extends StatefulWidget {
  final String? currentPlanId;
  final ValueChanged<Plan> onSelect;
  final VoidCallback? onBack;
  const PlansScreen({super.key, required this.onSelect, this.currentPlanId, this.onBack});
  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late final Future<List<Plan>> _plans = PlanRepo.load();

  Widget _card(Plan p) {
    final current = p.id == widget.currentPlanId;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: p.popular ? AppColors.accent : AppColors.border, width: p.popular ? 1.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            if (p.popular) const Chip(label: Text('Popular', style: TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
          ]),
          Text(p.blurb, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(p.pricePerMonth == 0 ? 'Free' : '\$${p.pricePerMonth.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            if (p.pricePerMonth > 0) const Padding(padding: EdgeInsets.only(bottom: 4, left: 2), child: Text('/mo', style: TextStyle(color: Colors.white54))),
          ]),
          const Divider(height: 20),
          _line('Sessions', limitText(p.maxSessions)),
          _line('Assets per session', limitText(p.maxAssets)),
          _line('Screenshots', limitText(p.maxScreenshots)),
          const SizedBox(height: 6),
          for (final f in p.features)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                const Icon(Icons.check, size: 15, color: AppColors.accent),
                const SizedBox(width: 6),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 12.5))),
              ]),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: p.popular ? ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.black) : null,
              onPressed: current ? null : () => widget.onSelect(p),
              child: Text(current ? 'Current plan' : (p.pricePerMonth == 0 ? 'Start free' : 'Choose ${p.name}')),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _line(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(k, style: const TextStyle(color: Colors.white60, fontSize: 12.5))),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          title: const Text('Choose your plan', style: TextStyle(fontSize: 17)),
          leading: widget.onBack == null ? null : IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        ),
        body: SafeArea(
          child: FutureBuilder<List<Plan>>(
            future: _plans,
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final plans = snap.data!;
              return LayoutBuilder(builder: (context, c) {
                final cols = c.maxWidth >= wideBreakpoint ? plans.length : (c.maxWidth >= 600 ? 2 : 1);
                const gap = 12.0;
                final w = (c.maxWidth - 32 - gap * (cols - 1)) / cols;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Wrap(spacing: gap, runSpacing: gap, alignment: WrapAlignment.center, children: [
                        for (final p in plans) SizedBox(width: w.clamp(240.0, 360.0), child: _card(p)),
                      ]),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      );
}
