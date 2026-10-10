import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dpl_inspection/main.dart';

void main() {
  testWidgets('empty form reports required fields and stays open', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: InspectionForm()));
    await tester.ensureVisible(find.byKey(const Key('saveButton')));
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pump();
    expect(find.text('Kode aset wajib diisi'), findsOneWidget);
    expect(find.text('Lokasi wajib diisi'), findsOneWidget);
    expect(find.byType(InspectionForm), findsOneWidget);
  });
}
