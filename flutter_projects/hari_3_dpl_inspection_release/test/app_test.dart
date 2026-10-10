import 'package:dpl_inspection_day_3/main.dart' as app_entrypoint;
import 'package:dpl_inspection_day_3/src/app.dart';
import 'package:dpl_inspection_day_3/src/screens/inspection_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('application entry point is available', () {
    expect(app_entrypoint.main, isA<Function>());
  });

  testWidgets('list renders all demo inspections', (tester) async {
    await tester.pumpWidget(const DplInspectionApp());
    expect(find.byType(InspectionListScreen), findsOneWidget);
    expect(find.text('PMP-001'), findsOneWidget);
    expect(find.text('PMP-002'), findsOneWidget);
    expect(find.text('GEN-003'), findsOneWidget);
  });
}
