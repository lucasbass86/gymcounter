import 'dart:convert';

class Measurement {
  final String id;
  double weight;
  DateTime date;

  Measurement({required this.id, required this.weight, required this.date});

  @override
  String toString() => '$date-$weight';

  Map<String, dynamic> toMap() {
    return {'id': id, 'weight': weight, 'date': date.millisecondsSinceEpoch};
  }

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] ?? '',
      weight: map['weight']?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Measurement.fromJson(String source) => Measurement.fromMap(json.decode(source));
}
