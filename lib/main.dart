import 'package:flutter/material.dart';
import 'data/plans.dart';
import 'screens/auth_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/replay_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? user;
  Plan? plan;
  bool changingPlan = false;

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (user == null) {
      home = AuthScreen(onAuthed: (e) => setState(() => user = e));
    } else if (plan == null || changingPlan) {
      home = PlansScreen(
        currentPlanId: plan?.id,
        onBack: plan == null ? () => setState(() => user = null) : () => setState(() => changingPlan = false),
        onSelect: (p) => setState(() {
          plan = p;
          changingPlan = false;
        }),
      );
    } else {
      home = ReplayScreen(
        user: user!,
        plan: plan!,
        onPlans: () => setState(() => changingPlan = true),
        onSignOut: () => setState(() {
          user = null;
          plan = null;
        }),
      );
    }
    return MaterialApp(debugShowCheckedModeBanner: false, theme: appTheme(), home: home);
  }
}
