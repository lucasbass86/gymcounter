import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/models/graphic_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class RecentExercisesListWidget extends StatelessWidget {
  final GymProvider gymProvider;
  const RecentExercisesListWidget({super.key, required this.gymProvider});

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = gymProvider.workouts
        .where((w) => Utils.fechaMenorOIgual(w.date, dias: gymProvider.daysOfRecentExercises))
        .toList();
    if (gymProvider.currentWorkout != null && !gymProvider.currentWorkout!.finished) {
      workouts.add(gymProvider.currentWorkout!);
    }
    workouts.sort((a, b) => b.date.compareTo(a.date));
    List<ExerciseSet> exercises = workouts.expand((workout) => workout.exercisesSet).toList();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Utils.iconDumbbell),
                  Text('Ejercicios recientes', style: TextStyle(fontSize: 17, color: Colors.white)),
                ],
              ),
              if (!Preferences.groupRecentExercises)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    exercises.length == 1 ? '1 ejercicio' : '${exercises.length} ejercicios',
                    style: TextStyle(color: AppColors.success),
                  ),
                ),
            ],
          ),
          (workouts.isEmpty)
              ? NoDataWidget(title: 'No hay ejercicios recientes')
              : Preferences.groupRecentExercises
              ? _grouped(workouts)
              : _list(workouts),
        ],
      ),
    );
  }

  Widget _grouped(List<Workout> workouts) {
    final Map<String, GraphicExerciseStatistics> grouped = {};

    for (final workout in workouts) {
      for (final exerciseSet in workout.exercisesSet) {
        final exercise = exerciseSet.exercise;
        final key = exercise.id;

        int reps = 0;
        Duration time = Duration.zero;

        for (final set in exerciseSet.sets) {
          reps += set.reps;
          if (set.time != null) {
            time += Duration(minutes: set.time!.inMinutes);
          }
        }

        final previous = grouped[key];

        grouped[key] = GraphicExerciseStatistics(
          exercise: exercise,
          totalReps: (previous?.totalReps ?? 0) + reps,
          totalTime: (previous?.totalTime ?? Duration.zero) + time,
          workouts: (previous?.workouts ?? [])..add(workout),
        );
      }
    }
    List<GraphicExerciseStatistics> list = grouped.values.toList();
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return RecentExerciseGroupedWidget(exercise: item);
      },
    );
  }

  Widget _list(List<Workout> workouts) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final Workout w = workouts[index];
        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: w.exercisesSet.length,
          itemBuilder: (BuildContext context, int index) {
            return RecentExerciseWidget(set: w.exercisesSet[index], workout: w);
          },
        );
      },
    );
  }
}
