import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/hive/boxes.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';

class GymProvider with ChangeNotifier {
  List<Exercise> exercises = [];
  List<Rutine> rutines = [];
  List<Workout> workouts = [];
  Workout? _currentWorkout;
  Workout? get currentWorkout => _currentWorkout;
  set currentWorkout(Workout? value) {
    _currentWorkout = value;
    if (_currentWorkout != null) {
      saveCurrentWorkout();
    } else {
      deleteCurrentWorkout();
    }
    notifyListeners();
  }

  int get daysOfRecentExercises => Preferences.daysOfRecentExercises;
  set daysOfRecentExercises(int value) {
    Preferences.daysOfRecentExercises = value;
    notifyListeners();
  }

  GymProvider() {
    loadData();
  }

  void loadData() {
    loadExercises();
    loadRutines();
    loadWorkouts();
    loadCurrentWorkout();
  }

  void notify() {
    notifyListeners();
  }

  //
  //EXERCISES
  //
  void loadExercises() {
    exercises = Boxes.exercises.keys.map((key) {
      final value = Boxes.exercises.get(key);
      return Exercise.fromJson(value);
    }).toList();

    notifyListeners();
  }

  bool addExercise(Exercise value) {
    try {
      exercises.add(value);
      Boxes.exercises.put(value.id, value.toJson());
      loadExercises();
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool updateExercise(Exercise value) {
    try {
      exercises.removeWhere((e) => e.id == value.id);
      exercises.add(value);
      Boxes.exercises.put(value.id, value.toJson());
      loadExercises();
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool removeExercise(Exercise value) {
    try {
      exercises.remove(value);
      Boxes.exercises.delete(value.id);
      loadExercises();
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool canRemove(Exercise exercise) {
    return false;
  }

  //OBTIENE LOS WORKOUTS DE LA SEMANA
  List<Workout> getWeeklyWorkOuts() {
    return workouts.where((w) => Utils.isInSameWeek(w.date)).toList();
  }

  //OBTIENE TODOS LOS SETS DE UN EJERCICIO
  List<SetResult> setsOfExercise(Exercise exercise) {
    return workouts
        .expand((workout) => workout.exercisesSet)
        .where((exerciseSet) => exerciseSet.exercise.id == exercise.id)
        .expand((exerciseSet) => exerciseSet.sets)
        .toList();
  }

  //OBTIENE EL MEJOR WORKOUT CON MAS SETS DE UN EJERCICIO
  Workout getBestWorkoutForExerciseSets(Exercise exercise) {
    return workouts.reduce((bestWorkout, workout) {
      final bestSets = totalSetsWorkoutExercise(bestWorkout, exercise);
      final workoutSets = totalSetsWorkoutExercise(workout, exercise);
      return workoutSets > bestSets ? workout : bestWorkout;
    });
  }

  //OBTIENE EL NUMERO DE SETS DE UN WORKOUT DE UN EJERCICIO
  int totalSetsWorkoutExercise(Workout workout, Exercise exercise) {
    return workout.exercisesSet
        .where((exerciseSet) => exerciseSet.exercise.id == exercise.id)
        .fold(0, (total, exerciseSet) => total + exerciseSet.sets.length);
  }

  ///
  ///REPETICIONES
  ///

  //OBTIENE EL TOTAL DE REPETICIONES DE UN EJERCICIO
  int totalRepsFromExercise(Exercise exercise) {
    int totalReps = workouts
        .expand((w) => w.exercisesSet.where((e) => e.exercise.id == exercise.id))
        .map((e) => e.sets.map((s) => s.reps).toList().fold(0, (p1, e1) => p1 + e1))
        .toList()
        .fold(0, (p2, e2) => p2 + e2);
    return totalReps;
  }

  //OBTIENE EL MEJOR WORKOUT POR REPETICIONES DE UN EJERCICIO
  Workout getBestWorkoutForExercise(Exercise exercise) {
    return workouts.reduce((bestWorkout, workout) {
      final bestReps = totalRepsFromExerciseFromWorkout(bestWorkout, exercise);
      final workoutReps = totalRepsFromExerciseFromWorkout(workout, exercise);
      return workoutReps > bestReps ? workout : bestWorkout;
    });
  }

  //OBTIENE EL TOTAL DE REPETICIONES DE UN WORKOUT DE UN EJERCICIO
  int totalRepsFromExerciseFromWorkout(Workout workout, Exercise exercise) {
    return workout.exercisesSet
        .where((exerciseSet) => exerciseSet.exercise.id == exercise.id)
        .expand((exerciseSet) => exerciseSet.sets)
        .fold(0, (total, set) => total + set.reps);
  }

  //OBTIENE EL TOTAL DE REPETICIONES TOTALES DE UN WORKOUT
  int totalRepsFromFromWorkout(Workout workout) {
    return workout.exercisesSet
        .expand((exerciseSet) => exerciseSet.sets)
        .fold(0, (total, set) => total + set.reps);
  }

  //OBTIENE EL MEJOR WORKOUT CON EL MAXIMO DE REPECICIONES DE UN EJERCICIO
  ({Workout? workout, int reps}) getWorkoutMaxRepsForExercise(Exercise exercise) {
    int maxReps = 0;
    Workout? bestWorkout;

    final allWorkouts = [if (currentWorkout != null) currentWorkout!, ...workouts];

    for (final workout in allWorkouts) {
      for (final exerciseSet in workout.exercisesSet) {
        if (exerciseSet.exercise.id == exercise.id) {
          for (final set in exerciseSet.sets) {
            if (set.reps > maxReps) {
              maxReps = set.reps;
              bestWorkout = workout;
            }
          }
        }
      }
    }
    return (workout: bestWorkout, reps: maxReps);
  }

  ///
  ///DURACIONES
  ///

  //OBTIENE LA DURACION TOTAL DE TODOS LOS WORKOUTS DE UN EJERCICIO
  Duration getTotalTimeForExercise(Exercise exercise) {
    Duration total = Duration.zero;
    for (final workout in workouts) {
      for (final exerciseSet in workout.exercisesSet) {
        if (exerciseSet.exercise.id != exercise.id) {
          continue;
        }
        for (final set in exerciseSet.sets) {
          total += set.time!;
        }
      }
    }
    return total;
  }

  //OBTIENE EL MEJOR WORKOUT POR TIEMPO DE UN EJERCICIO
  Workout getWorkoutWithMostTimeForExercise(Exercise exercise) {
    return workouts.reduce((bestWorkout, workout) {
      final bestTime = getExerciseTime(bestWorkout, exercise);
      final workoutTime = getExerciseTime(workout, exercise);
      return workoutTime > bestTime ? workout : bestWorkout;
    });
  }

  //OBTIENE LA DURACIÓN TOTAL DE UN EJERCICIO
  Duration getExerciseTime(Workout workout, Exercise exercise) {
    Duration total = Duration.zero;
    for (final exerciseSet in workout.exercisesSet) {
      if (exerciseSet.exercise.id != exercise.id) {
        continue;
      }
      for (final set in exerciseSet.sets) {
        total += set.time!;
      }
    }
    return total;
  }

  //OBTIENE EL MEJOR WORKOUT CON TIEMPO
  ({Workout workout, Duration time}) getBestWorkoutTimeForExercise(Exercise exercise) {
    Workout? bestWorkout;
    Duration bestTime = Duration.zero;

    for (final workout in workouts) {
      final time = getExerciseTime(workout, exercise);

      if (time > bestTime) {
        bestTime = time;
        bestWorkout = workout;
      }
    }

    return (workout: bestWorkout!, time: bestTime);
  }

  Workout getWorkoutWithBestSetTimeForExercise(Exercise exercise) {
    return workouts.reduce((bestWorkout, workout) {
      final bestTime = getBestSetTime(bestWorkout, exercise);
      final workoutTime = getBestSetTime(workout, exercise);
      return workoutTime > bestTime ? workout : bestWorkout;
    });
  }

  Duration getBestSetTime(Workout workout, Exercise exercise) {
    Duration bestTime = Duration.zero;

    for (final exerciseSet in workout.exercisesSet) {
      if (exerciseSet.exercise.id != exercise.id) {
        continue;
      }
      for (final set in exerciseSet.sets) {
        final time = set.time!;

        if (time > bestTime) {
          bestTime = time;
        }
      }
    }
    return bestTime;
  }

  //OBTIENE EL TOTAL DE DURATION DE UN WORKOUT
  Duration totalDurationFromFromWorkout(Workout workout) {
    return workout.exercisesSet
        .expand((exerciseSet) => exerciseSet.sets)
        .fold(
          Duration.zero,
          (total, set) => total + (set.time != null ? set.time! : Duration.zero),
        );
  }

  ///
  ///HISTORIAL
  ///
  List<ExerciseSet> getExerciseSetsByHistory(
    HistoryMode mode,
    DateTime date, [
    Exercise? exercise,
  ]) {
    return workouts
        .where((workout) => _isWorkoutInPeriod(workout, mode, date))
        .expand((workout) => workout.exercisesSet)
        .where((exerciseSet) => exercise == null || exerciseSet.exercise.id == exercise.id)
        .toList();
  }

  List<Workout> getWorkoutsByHistory(HistoryMode mode, DateTime date, [Exercise? exercise]) {
    return workouts
        .where((workout) => _isWorkoutInPeriod(workout, mode, date))
        .where(
          (workout) =>
              exercise == null ||
              workout.exercisesSet.any((exerciseSet) => exerciseSet.exercise.id == exercise.id),
        )
        .toList();
  }

  bool _isWorkoutInPeriod(Workout workout, HistoryMode mode, DateTime date) {
    switch (mode) {
      case HistoryMode.day:
        return workout.date.year == date.year &&
            workout.date.month == date.month &&
            workout.date.day == date.day;
      case HistoryMode.week:
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final end = start.add(const Duration(days: 7));
        return !workout.date.isBefore(start) && workout.date.isBefore(end);
      case HistoryMode.month:
        return workout.date.year == date.year && workout.date.month == date.month;
      case HistoryMode.year:
        return workout.date.year == date.year;
    }
  }

  ///
  ///CURRENT WORKOUT
  ///
  void loadCurrentWorkout() {
    List<Workout> list = Boxes.currentWorkout.keys.map((key) {
      final value = Boxes.currentWorkout.get(key);
      return Workout.fromJson(value);
    }).toList();
    if (list.isNotEmpty) {
      currentWorkout = list[0];
      if (!Utils.isToday(currentWorkout!.date)) {
        currentWorkout!.finished = true;
        addWorkout(currentWorkout!);
        currentWorkout = null;
      }
    }
  }

  bool saveCurrentWorkout() {
    try {
      Boxes.currentWorkout.put(currentWorkout!.id, currentWorkout!.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteCurrentWorkout() {
    try {
      Boxes.currentWorkout.deleteAt(0);
      return true;
    } catch (e) {
      return false;
    }
  }

  //
  //RUTINES
  //
  void loadRutines() {
    rutines = Boxes.rutines.keys.map((key) {
      final value = Boxes.rutines.get(key);
      return Rutine.fromJson(value);
    }).toList();

    notifyListeners();
  }

  bool addRutine(Rutine rutine) {
    try {
      if (!rutines.any((r) => r.id == rutine.id)) rutines.add(rutine);
      Boxes.rutines.put(rutine.id, rutine.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteRutine(Rutine rutine) {
    try {
      rutines.remove(rutine);
      Boxes.rutines.delete(rutine.id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///
  ///WORKOUTS
  ///

  void loadWorkouts() {
    workouts = Boxes.workouts.keys.map((key) {
      final value = Boxes.workouts.get(key);
      return Workout.fromJson(value);
    }).toList();

    notifyListeners();
  }

  bool addWorkout(Workout workout) {
    try {
      if (!workouts.any((w) => w.id == workout.id)) workouts.add(workout);
      Boxes.workouts.put(workout.id, workout.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteWorkout(Workout workout) {
    try {
      workouts.remove(workout);
      Boxes.workouts.delete(workout.id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Workout getWorkoutFromExerciseSet(ExerciseSet exercise) {
    if (currentWorkout?.exercisesSet.any((e) => e.id == exercise.id) ?? false) {
      return currentWorkout!;
    }
    return workouts.firstWhere((workout) => workout.exercisesSet.any((e) => e.id == exercise.id));
  }
}
