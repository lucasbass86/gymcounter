import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ExerciseHistoryWidget extends StatelessWidget {
  final Exercise exercise;
  final List<Workout> workouts;
  const ExerciseHistoryWidget({super.key, required this.exercise, required this.workouts});

  @override
  Widget build(BuildContext context) {
    GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
    return ListView.separated(
      physics: const BouncingScrollPhysics(parent: ClampingScrollPhysics()),
      itemCount: workouts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (exercise.type == ExerciseType.reps) {
          return _ExerciseReps(
            exercise: exercise,
            workout: workouts[index],
            gymProvider: gymProvider,
          );
        } else {
          return _ExerciseTime(
            exercise: exercise,
            workout: workouts[index],
            gymProvider: gymProvider,
          );
        }
      },
      separatorBuilder: (context, index) => Divider(color: AppColors.divider),
    );
  }
}

class _ExerciseReps extends StatelessWidget {
  final Exercise exercise;
  final Workout workout;
  final GymProvider gymProvider;
  const _ExerciseReps({required this.exercise, required this.workout, required this.gymProvider});

  @override
  Widget build(BuildContext context) {
    //MAX REPS
    final result = gymProvider.getWorkoutMaxRepsForExercise(exercise);
    final int bestReps = result.reps;
    //BEST
    final bestWorkout = gymProvider.getBestWorkoutForExercise(exercise);

    final List<SetResult> sets = workout.exercisesSet
        .where((e) => e.exercise.id == exercise.id)
        .expand((s) => s.sets)
        .toList();
    final int numSets = sets.length;
    final int maxReps = sets.map((set) => set.reps).reduce((a, b) => a > b ? a : b);
    final int totalReps = sets.fold(0, (p, e) => p + e.reps);
    String sReps = sets.map((e) => e.reps.toString()).join(' · ');
    sReps += ' reps';

    return BounceableWidget(
      onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: workout),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 20,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(width: 1, height: 50, color: AppColors.success),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.shortdateEnglishToSpanish(workout.date.toString()),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(Utils.getNombreDia(workout.date)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numSets ${numSets == 1 ? 'serie' : 'series'}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 120, child: Text(sReps, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
          Row(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (maxReps == bestReps && workout.id != bestWorkout.id)
                Icon(Utils.iconRecors, color: AppColors.success),
              if (workout.id == bestWorkout.id) Icon(Utils.iconRecors, color: AppColors.warning),
              Row(
                spacing: 3,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$totalReps', style: TextStyle(color: Colors.white)),
                      Text('reps'),
                    ],
                  ),
                  Icon(Utils.iconForward, color: AppColors.success, size: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExerciseTime extends StatelessWidget {
  final Exercise exercise;
  final Workout workout;
  final GymProvider gymProvider;
  const _ExerciseTime({required this.exercise, required this.workout, required this.gymProvider});

  @override
  Widget build(BuildContext context) {
    Workout? bestWorkoutSetTime;
    Duration? bestSetTime;

    //MAX TIME
    bestWorkoutSetTime = gymProvider.getWorkoutWithBestSetTimeForExercise(exercise);
    bestSetTime = gymProvider.getBestSetTime(bestWorkoutSetTime, exercise);

    //BEST
    final bestWorkout = gymProvider.getBestWorkoutTimeForExercise(exercise);

    final List<SetResult> sets = workout.exercisesSet
        .where((e) => e.exercise.id == exercise.id)
        .expand((s) => s.sets)
        .toList();
    final int numSets = sets.length;
    final Duration bestSet = gymProvider.getBestSetTime(workout, exercise);

    final Duration totalDuration = gymProvider.getExerciseTime(workout, exercise);
    String sReps = sets.map((e) => Utils.durationToString(e.time!)).join(' · ');

    return BounceableWidget(
      onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: workout),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 20,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(width: 1, height: 50, color: AppColors.success),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.shortdateEnglishToSpanish(workout.date.toString()),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(Utils.getNombreDia(workout.date)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numSets ${numSets == 1 ? 'serie' : 'series'}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 120, child: Text(sReps, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
          Row(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bestSetTime == bestSet && workout.id != bestWorkout.workout.id)
                Icon(Utils.iconRecors, color: AppColors.success),
              if (workout.id == bestWorkout.workout.id)
                Icon(Utils.iconRecors, color: AppColors.warning),
              Row(
                spacing: 3,
                children: [
                  Text(
                    Utils.durationToString(totalDuration),
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Utils.iconForward, color: AppColors.success, size: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
