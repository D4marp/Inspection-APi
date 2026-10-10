import 'package:flutter/material.dart';

import '../models/inspection.dart';
import '../widgets/photo_panel.dart';

class InspectionDetailScreen extends StatelessWidget {
  const InspectionDetailScreen({super.key, required this.item});
  final Inspection item;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail inspeksi')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            item.assetCode,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(
                item.condition == InspectionCondition.good
                    ? Icons.check_circle
                    : Icons.warning_amber,
              ),
              label: Text(item.condition.label),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Lokasi'),
            subtitle: Text(item.location),
          ),
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: const Text('Catatan'),
            subtitle: Text(item.note),
          ),
          const SizedBox(height: 12),
          PhotoPanel(key: ValueKey(item.id), inspectionId: item.id),
        ],
      ),
    ),
  );
}
