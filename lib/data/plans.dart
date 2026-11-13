/// Plan rows. Limits live in this table, never in screen code.
/// Swap [PlanRepo.load] for a database/API query (a `plans` table) later;
/// screens only read the fields below.
class Plan {
  final String id, name, blurb;
  final double pricePerMonth;
  final int maxSessions, maxAssets, maxScreenshots; // -1 = unlimited
  final List<String> features;
  final bool popular;
  const Plan({
    required this.id,
    required this.name,
    required this.blurb,
    required this.pricePerMonth,
    required this.maxSessions,
    required this.maxAssets,
    required this.maxScreenshots,
    required this.features,
    this.popular = false,
  });
}

String limitText(int v) => v < 0 ? 'Unlimited' : '$v';

class PlanRepo {
  static Future<List<Plan>> load() async => _rows;

  static const _rows = <Plan>[
    Plan(
      id: 'free',
      name: 'Free',
      blurb: 'Try the replay.',
      pricePerMonth: 0,
      maxSessions: 3,
      maxAssets: 1,
      maxScreenshots: 10,
      features: ['Fake broker', 'Basic stats', 'Journal'],
    ),
    Plan(
      id: 'pro',
      name: 'Pro',
      blurb: 'For daily practice.',
      pricePerMonth: 12,
      maxSessions: 25,
      maxAssets: 5,
      maxScreenshots: 500,
      features: ['Everything in Free', 'Full stats breakdowns', 'Drawings autosave', 'Tags & screenshots'],
      popular: true,
    ),
    Plan(
      id: 'elite',
      name: 'Elite',
      blurb: 'Teams and heavy users.',
      pricePerMonth: 29,
      maxSessions: -1,
      maxAssets: 5,
      maxScreenshots: -1,
      features: ['Everything in Pro', 'Unlimited sessions', 'Priority support'],
    ),
  ];
}
