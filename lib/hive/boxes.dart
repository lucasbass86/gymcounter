import 'package:hive/hive.dart';

class Boxes {
  //EJERCICIOS
  static final String boxNameExercises = 'GymCounterExercises';
  static final Box exercises = Hive.box(boxNameExercises);

  //CONTROL DE PESO
  static final String boxNameWeight = 'GymCounterWeight';
  static final Box weights = Hive.box(boxNameWeight);

  //WORKOUTS
  static final String boxNameWorkouts = 'GymCounterWorkouts';
  static final Box workouts = Hive.box(boxNameWorkouts);

  //CURRENT WORKOUT
  static final String boxNameCurrentWorkout = 'GymCounterCurrentWorkout';
  static final Box currentWorkout = Hive.box(boxNameCurrentWorkout);

  //RUTINAS
  static final String boxNameRutines = 'GymCounterRutines';
  static final Box rutines = Hive.box(boxNameRutines);

  //TARGETS
  static final String boxNameTargets = 'GymCounterTargets';
  static final Box targets = Hive.box(boxNameTargets);
}
