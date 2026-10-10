import 'package:flutter/material.dart';

import 'models/inspection.dart';
import 'screens/inspection_detail_screen.dart';
import 'screens/inspection_list_screen.dart';

const screenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

class DplInspectionApp extends StatelessWidget {
  const DplInspectionApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DPL Inspection',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006a60)),
      useMaterial3: true,
    ),
    home: screenshotMode
        ? InspectionDetailScreen(item: demoInspections[1])
        : const InspectionListScreen(),
  );
}
