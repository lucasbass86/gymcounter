import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';

class Rutine {
  final String id;
  String name;
  DateTime date;
  List<ExerciseSet> exercisesSet;
  bool finished;
  Difficulty difficulty;
  final String idWorkout;
  Duration time;

  @override
  String toString() => name;

  int get totalReps {
    return exercisesSet.fold(
      0,
      (totalExercises, exercise) =>
          totalExercises + exercise.sets.fold(0, (totalSets, set) => totalSets + set.reps),
    );
  }

  Duration get totalTime {
    return exercisesSet.fold(
      Duration.zero,
      (totalExercises, exercise) =>
          totalExercises +
          exercise.sets.fold(
            Duration.zero,
            (totalSets, set) => totalSets + (set.time != null ? set.time! : Duration.zero),
          ),
    );
  }

  Rutine({
    required this.name,
    required this.date,
    required this.exercisesSet,
    required this.difficulty,
    required this.time,
    this.finished = false,
    this.idWorkout = '',
  }) : id = Uuid().v4();

  Rutine.withId({
    required this.id,
    required this.name,
    required this.date,
    required this.exercisesSet,
    required this.difficulty,
    required this.time,
    this.finished = false,
    this.idWorkout = '',
  });

  factory Rutine.fromWorkout(Workout workout) {
    return Rutine(
      name: workout.name,
      date: workout.date,
      exercisesSet: workout.exercisesSet,
      difficulty: workout.difficulty,
      time: workout.time,
      idWorkout: workout.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'exercisesSet': exercisesSet.map((x) => x.toMap()).toList(),
      'finished': finished,
      'difficulty': difficulty.index,
      'idWorkout': idWorkout,
      'time': time.inSeconds,
    };
  }

  factory Rutine.fromMap(Map<String, dynamic> map) {
    return Rutine.withId(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      exercisesSet: List<ExerciseSet>.from(map['exercisesSet']?.map((x) => ExerciseSet.fromMap(x))),
      finished: map['finished'] ?? false,
      difficulty: Difficulty.values.elementAt(map['difficulty']),
      idWorkout: map['idWorkout'] ?? '',
      time: map.containsKey('time')
          ? (map['time'] is String)
                ? Utils.timeOfDayFromJsonToDuration(map['time'])
                : Duration(seconds: map['time'])
          : Duration.zero,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rutine.fromJson(String source) => Rutine.fromMap(json.decode(source));

  Rutine copyWith({
    String? id,
    String? name,
    DateTime? date,
    List<ExerciseSet>? exercisesSet,
    bool? finished,
    Difficulty? difficulty,
    String? idWorkout,
    Duration? time,
  }) {
    return Rutine.withId(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      exercisesSet: exercisesSet ?? this.exercisesSet.map((e) => e.copyWith(id: id)).toList(),
      finished: finished ?? this.finished,
      difficulty: difficulty ?? this.difficulty,
      idWorkout: idWorkout ?? this.idWorkout,
      time: time ?? this.time,
    );
  }
}
