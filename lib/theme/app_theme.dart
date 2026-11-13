import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B0D12);
  static const surface = Color(0xFF131722);
  static const border = Color(0xFF232838);
  static const accent = Color(0xFF2EBD9B);
  static const up = Colors.teal;
  static const down = Colors.redAccent;
  static const buy = Color(0xFF1F6B5C);
  static const sell = Color(0xFF7A2D31);
}

/// Width at which layouts switch from phone (single column) to web/desktop (side by side).
const double wideBreakpoint = 900;

ThemeData appTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: base.colorScheme.copyWith(primary: AppColors.accent, surface: AppColors.surface),
    visualDensity: VisualDensity.compact,
    cardTheme: CardThemeData(
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, space: 12, thickness: 1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: shape,
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(shape: shape, minimumSize: const Size(0, 44), side: const BorderSide(color: AppColors.border)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: AppColors.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.accent)),
    ),
    switchTheme: const SwitchThemeData(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
  );
}
