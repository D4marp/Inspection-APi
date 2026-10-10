import 'package:flutter/material.dart';

import '../models/inspection.dart';
import 'inspection_detail_screen.dart';

class InspectionListScreen extends StatelessWidget {
  const InspectionListScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('DPL Inspection')),
    body: SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoInspections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = demoInspections[index];
          return Card(
            child: ListTile(
              key: ValueKey(item.id),
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                child: Icon(
                  item.condition == InspectionCondition.good
                      ? Icons.check
                      : Icons.warning_amber,
                ),
              ),
              title: Text(
                item.assetCode,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${item.location}\n${item.condition.label}'),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => InspectionDetailScreen(item: item),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
