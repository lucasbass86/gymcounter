import 'dart:convert';

import 'package:gymcounter/helpers/utils.dart';
import 'package:uuid/uuid.dart';

class Target {
  final String id;
  final DateTime date;
  final int value;
  final int target;

  @override
  String toString() => '${Utils.dateEnglishToSpanish(date)}:$value/$target';

  Target({required this.date, required this.value, required this.target}) : id = Uuid().v4();

  Target.withId({required this.id, required this.date, required this.value, required this.target});

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.millisecondsSinceEpoch,
    'value': value,
    'target': target,
  };

  factory Target.fromMap(Map<String, dynamic> map) {
    return Target.withId(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? 0,
      target: map['target'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Target.fromJson(String source) => Target.fromMap(json.decode(source));
}
