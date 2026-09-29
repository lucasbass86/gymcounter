import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ResumeWidget extends StatelessWidget {
  final GymProvider gymProvider;
  final VoidCallback onTap;
  const ResumeWidget({super.key, required this.gymProvider, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = gymProvider.workouts.where((w) => Utils.isToday(w.date)).toList();
    if (gymProvider.currentWorkout != null && !gymProvider.currentWorkout!.finished) {
      workouts.add(gymProvider.currentWorkout!);
    }
    int numOfExercises = workouts.fold(0, (p, e) => p + e.exercisesSet.length);
    int reps = workouts.fold(
      0,
      (p1, e1) =>
          p1 + e1.exercisesSet.fold(0, (p2, e2) => p2 + e2.sets.fold(0, (p3, e3) => p3 + e3.reps)),
    );
    Duration totalDuration = workouts.fold(
      Duration.zero,
      (p1, e1) =>
          p1 +
          e1.exercisesSet.fold(
            Duration.zero,
            (p2, e2) =>
                p2 +
                e2.sets.fold(
                  Duration.zero,
                  (p3, e3) => p3 + (e3.time != null ? e3.time! : Duration.zero),
                ),
          ),
    );
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Utils.iconCalendar),
                  Text('Resumen de hoy', style: TextStyle(fontSize: 20)),
                ],
              ),
              Divider(color: AppColors.divider),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 290,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _exercises(numOfExercises),
                          Divider(color: AppColors.divider),
                          _totalReps(reps),
                          Divider(color: AppColors.divider),
                          _totalTime(totalDuration),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 290, color: AppColors.divider),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [_percentDaily(reps), _percentWeekly(reps)],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _percentDaily(int reps) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Objetivo diario', textAlign: TextAlign.left),
        Center(
          child: CircularProgressWidget(
            currentValue: reps,
            totalValue: Preferences.respForDay,
            size: 100,
            strokeWidthOutter: 7,
            strokeWidthInner: 5,
            fontSize: 33,
            progressColor: Utils.progressColor(reps, Preferences.respForDay),
          ),
        ),
      ],
    );
  }

  Widget _percentWeekly(int reps) {
    List<Workout> weekly = gymProvider.getWeeklyWorkOuts();
    int totalReps = weekly.fold(0, (p1, e1) => p1 + e1.totalReps);
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Objetivo semanal', textAlign: TextAlign.left),
        Center(
          child: CircularProgressWidget(
            currentValue: totalReps,
            totalValue: Preferences.respForDay * 7,
            size: 100,
            strokeWidthOutter: 7,
            strokeWidthInner: 5,
            fontSize: 33,
            progressColor: Utils.progressColor(totalReps, Preferences.respForDay * 7),
          ),
        ),
      ],
    );
  }

  Widget _totalReps(int reps) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repeticiones totales'),
        CountUp(
          value: reps,
          style: TextStyle(fontSize: 35, color: AppColors.success),
        ),
      ],
    );
  }

  Widget _totalTime(Duration totalDuration) {
    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text('Tiempo total'),
          Row(
            spacing: 10,
            children: [
              Icon(Utils.iconTimer),
              CountUpDuration(duration: totalDuration, style: TextStyle(fontSize: 30)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exercises(int numOfExercises) {
    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text('Ejercicios'),
          CountUp(
            value: numOfExercises,
            style: TextStyle(fontSize: 35, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
