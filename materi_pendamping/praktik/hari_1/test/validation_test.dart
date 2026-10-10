import 'package:flutter_test/flutter_test.dart';
import 'package:dpl_inspection/validation.dart';
import 'package:dpl_inspection/inspection.dart';

void main() {
  test('good allows empty note', () => expect(validateNote('good', ''), isNull));
  test('needs_action rejects trimmed short note', () =>
    expect(validateNote('needs_action', '  cek  '), isNotNull));
  test('needs_action accepts descriptive note', () =>
    expect(validateNote('needs_action', 'Motor bergetar tinggi'), isNull));
  test('rejects note over 500 chars', () =>
    expect(validateNote('good', List.filled(501, 'x').join()), isNotNull));
  test('parses and round trips server JSON', () {
    final json = <String, dynamic>{'id':'1','assetCode':'PMP-001',
      'location':'Workshop A','condition':'good','note':'',
      'createdAt':'2026-10-03T01:00:00Z'};
    final model = Inspection.fromJson(json);
    expect(model.id, '1');
    expect(model.createdAt.isUtc, isTrue);
    expect(Inspection.fromJson(model.toJson()).assetCode, 'PMP-001');
  });
  test('missing required field is not silently accepted', () {
    expect(() => Inspection.fromJson({'id':'1'}), throwsA(isA<TypeError>()));
  });
}
