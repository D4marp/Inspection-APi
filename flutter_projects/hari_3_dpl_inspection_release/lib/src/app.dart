import 'package:flutter/material.dart';

import 'screens/migration_hub_screen.dart';

const screenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

class DplInspectionApp extends StatelessWidget {
  const DplInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xff0b1f3a);
    const teal = Color(0xff0f8b8d);
    const gold = Color(0xffd6a94a);
    final colors = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      primary: navy,
      secondary: teal,
      tertiary: gold,
      surface: const Color(0xfff7f8fb),
    );

    return MaterialApp(
      title: 'DPL Migration Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colors,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff3f5f8),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: teal.withValues(alpha: 0.16),
        ),
      ),
      home: const MigrationHubScreen(),
    );
  }
}
