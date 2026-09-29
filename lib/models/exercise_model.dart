import 'dart:convert';

import 'package:gymcounter/helpers/enums.dart';

class Exercise {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final Difficulty difficulty;
  final String image;
  final ExerciseType type;
  final String note;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.difficulty,
    required this.equipment,
    required this.image,
    required this.type,
    this.note = '',
  });

  @override
  String toString() => name;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup.name,
      'equipment': equipment.name,
      'difficulty': difficulty.name,
      'image': image,
      'type': type.name,
      'note': note,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      muscleGroup: MuscleGroup.values.byName(map['muscleGroup']),
      equipment: Equipment.values.byName(map['equipment']),
      difficulty: Difficulty.values.byName(map['difficulty']),
      image: map['image'] ?? '',
      type: ExerciseType.values.byName(map['type']),
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) => Exercise.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup &&
        other.equipment == equipment &&
        other.difficulty == difficulty &&
        other.image == image &&
        other.type == type &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        muscleGroup.hashCode ^
        equipment.hashCode ^
        difficulty.hashCode ^
        image.hashCode ^
        type.hashCode ^
        note.hashCode;
  }
}

class ExampleExercise extends Exercise {
  ExampleExercise({
    required super.id,
    required super.name,
    required super.muscleGroup,
    required super.equipment,
    required super.difficulty,
    required super.image,
    required super.type,
  });
}

class ExerciseStatistics {
  final Exercise exercise;
  final int reps;
  final Duration duration;

  @override
  String toString() => exercise.name;

  ExerciseStatistics({required this.exercise, required this.reps, required this.duration});
}
