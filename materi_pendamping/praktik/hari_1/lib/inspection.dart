class Inspection {
  final String id, assetCode, location, condition, note;
  final DateTime createdAt;
  const Inspection({required this.id, required this.assetCode,
    required this.location, required this.condition, required this.note,
    required this.createdAt});
  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
    id: json['id'] as String, assetCode: json['assetCode'] as String,
    location: json['location'] as String, condition: json['condition'] as String,
    note: (json['note'] as String?) ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String).toUtc());
  Map<String, dynamic> toJson() => {'id': id, 'assetCode': assetCode,
    'location': location, 'condition': condition, 'note': note,
    'createdAt': createdAt.toUtc().toIso8601String()};
}
