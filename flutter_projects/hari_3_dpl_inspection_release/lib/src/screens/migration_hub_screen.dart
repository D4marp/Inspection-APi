import 'package:flutter/material.dart';

import 'agent_skill_screen.dart';
import 'inspection_list_screen.dart';
import 'migration_prd_screen.dart';
import 'training_webview_screen.dart';

class MigrationHubScreen extends StatefulWidget {
  const MigrationHubScreen({super.key});

  @override
  State<MigrationHubScreen> createState() => _MigrationHubScreenState();
}

class _MigrationHubScreenState extends State<MigrationHubScreen> {
  var _index = 0;

  static const _titles = <String>[
    'PRD Migrasi Kotlin',
    'WebView Lab',
    'Flutter Target',
    'Agent Skill',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_titles[_index]),
          const Text(
            'DPL • Hari 3 Migration Lab',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    body: switch (_index) {
      0 => const MigrationPrdScreen(),
      1 => const TrainingWebViewScreen(),
      2 => const InspectionListScreen(embedded: true),
      _ => const AgentSkillScreen(),
    },
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment),
          label: 'PRD',
        ),
        NavigationDestination(
          icon: Icon(Icons.web_outlined),
          selectedIcon: Icon(Icons.web),
          label: 'WebView',
        ),
        NavigationDestination(
          icon: Icon(Icons.phone_android_outlined),
          selectedIcon: Icon(Icons.phone_android),
          label: 'Target',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined),
          selectedIcon: Icon(Icons.auto_awesome),
          label: 'Skill',
        ),
      ],
    ),
  );
}
