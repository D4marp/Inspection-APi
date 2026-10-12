import 'package:dpl_inspection_day_3/main.dart' as app_entrypoint;
import 'package:dpl_inspection_day_3/src/app.dart';
import 'package:dpl_inspection_day_3/src/screens/agent_skill_screen.dart';
import 'package:dpl_inspection_day_3/src/screens/migration_prd_screen.dart';
import 'package:dpl_inspection_day_3/src/webview/navigation_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('application entry point is available', () {
    expect(app_entrypoint.main, isA<Function>());
  });

  testWidgets('app opens the Kotlin migration PRD', (tester) async {
    await tester.pumpWidget(const DplInspectionApp());
    expect(find.byType(MigrationPrdScreen), findsOneWidget);
    expect(find.text('Migrate by vertical slice'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Acceptance criteria'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Acceptance criteria'), findsOneWidget);
  });

  testWidgets('agent skill states its real repository path', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AgentSkillScreen())),
    );
    expect(find.text(AgentSkillScreen.skillPath), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Guardrail'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Guardrail'), findsOneWidget);
  });

  test('WebView policy allows local content and blocks remote origins', () {
    expect(TrainingNavigationPolicy.allows('about:blank'), isTrue);
    expect(
      TrainingNavigationPolicy.allows('file:///flutter_assets/guide.html'),
      isTrue,
    );
    expect(TrainingNavigationPolicy.allows('https://example.com'), isFalse);
    expect(TrainingNavigationPolicy.allows('javascript:alert(1)'), isFalse);
  });
}
