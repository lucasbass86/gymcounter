import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:gymcounter/models/_models.dart';

class ExerciseSet {
  final String id;
  int order;
  Exercise exercise;
  final List<SetResult> sets;

  @override
  String toString() => exercise.name;

  ExerciseSet({required this.exercise, required this.sets, required this.order}) : id = Uuid().v4();

  ExerciseSet.withId({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.order,
  });

  void addSet(SetResult set) {
    sets.add(set);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'exercise': exercise.toMap(),
      'sets': sets.map((x) => x.toMap()).toList(),
    };
  }

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet.withId(
      id: map['id'] ?? '',
      order: map['order']?.toInt() ?? 0,
      exercise: Exercise.fromMap(map['exercise']),
      sets: List<SetResult>.from(map['sets']?.map((x) => SetResult.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSet.fromJson(String source) => ExerciseSet.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExerciseSet && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  ExerciseSet copyWith({String? id, int? order, Exercise? exercise, List<SetResult>? sets}) {
    return ExerciseSet.withId(
      id: id ?? this.id,
      order: order ?? this.order,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets.map((e) => e.copyWith(id: id)).toList(),
    );
  }
}
