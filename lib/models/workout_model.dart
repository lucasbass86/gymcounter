import 'dart:convert';

import 'package:gymcounter/helpers/utils.dart';
import 'package:uuid/uuid.dart';

import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/models/_models.dart';

class Workout {
  final String id;
  String name;
  DateTime date;
  Duration time;
  Difficulty difficulty;
  List<ExerciseSet> exercisesSet;
  bool finished;
  String idRutine;

  @override
  String toString() => '$id-${Utils.dateEnglishToSpanish(date)}:$name';

  Workout({
    required this.name,
    required this.date,
    required this.time,
    required this.difficulty,
    required this.exercisesSet,
    this.finished = false,
    this.idRutine = '',
  }) : id = Uuid().v4();

  Workout.withId({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.difficulty,
    required this.exercisesSet,
    this.finished = false,
    this.idRutine = '',
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'time': time.inSeconds,
      'difficulty': difficulty.index,
      'exercisesSet': exercisesSet.map((x) => x.toMap()).toList(),
      'finished': finished,
      'idRutine': idRutine,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout.withId(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      time: map.containsKey('time')
          ? (map['time'] is String)
                ? Utils.timeOfDayFromJsonToDuration(map['time'])
                : Duration(seconds: map['time'])
          : Duration.zero,
      difficulty: Difficulty.values.elementAt(map['difficulty']),
      exercisesSet: List<ExerciseSet>.from(map['exercisesSet']?.map((x) => ExerciseSet.fromMap(x))),
      finished: map['finished'] ?? false,
      idRutine: map['idRutine'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) => Workout.fromMap(json.decode(source));

  factory Workout.fromRutine(Rutine rutine, Duration duration) {
    return Workout(
      name: rutine.name,
      date: DateTime.now(),
      exercisesSet: rutine.exercisesSet,
      difficulty: rutine.difficulty,
      time: duration,
      finished: true,
      idRutine: rutine.id,
    );
  }
}
