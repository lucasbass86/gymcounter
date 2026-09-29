import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';

class GraphicExerciseReps {
  final Exercise exercise;
  final int reps;
  final double weight;
  final DateTime date;
  GraphicExerciseReps({
    required this.exercise,
    required this.reps,
    required this.weight,
    required this.date,
  });
}

class GraphicExerciseTime {
  final Exercise exercise;
  final Duration time;
  final DateTime date;
  GraphicExerciseTime({required this.exercise, required this.time, required this.date});
}

class GraphicExerciseWorkouts {
  final Exercise exercise;
  final int workouts;
  final DateTime date;
  GraphicExerciseWorkouts({required this.exercise, required this.workouts, required this.date});
}

class GraphicStatisticsReps {
  final DateTime date;
  final int workouts;
  GraphicStatisticsReps({required this.date, required this.workouts});
}

class GraphicStatisticsDuration {
  final DateTime date;
  final Duration duration;
  GraphicStatisticsDuration({required this.date, required this.duration});
}

class GraphicRutineWorkouts {
  final Rutine rutine;
  final int workouts;
  final DateTime date;
  GraphicRutineWorkouts({required this.rutine, required this.workouts, required this.date});
}

class GraphicRutineTime {
  final Rutine rutine;
  final Duration time;
  final DateTime date;
  GraphicRutineTime({required this.rutine, required this.time, required this.date});
}

class GraphicRutineReps {
  final Rutine rutine;
  final int reps;
  final DateTime date;
  GraphicRutineReps({required this.rutine, required this.reps, required this.date});
}

class GraphicExerciseStatistics {
  final Exercise exercise;
  final int totalReps;
  final Duration totalTime;
  List<Workout> workouts;

  @override
  String toString() =>
      '${exercise.name}:Reps:$totalReps:Time:${Utils.durationToString(totalTime)}:W:${workouts.length}';

  GraphicExerciseStatistics({
    required this.exercise,
    required this.totalReps,
    required this.totalTime,
    required this.workouts,
  });
}
