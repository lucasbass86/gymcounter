import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticsExerciseWidget extends StatelessWidget {
  final ExerciseStatistics statistic;
  final int totalReps;
  final Duration totalDuration;
  const StatisticsExerciseWidget({
    super.key,
    required this.statistic,
    required this.totalReps,
    required this.totalDuration,
  });

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      onTap: () =>
          Navigator.pushNamed(context, ExercisePage.routeName, arguments: statistic.exercise.id),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [
            GestureDetector(
              onLongPress: () => showImage(context, statistic.exercise.image),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.background.withAlpha(100),
                ),
                child: Image.asset(statistic.exercise.image, width: 30, height: 30),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statistic.exercise.name, style: TextStyle(color: Colors.white)),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double w = constraints.maxWidth;
                      return ProgressBarWidget(
                        width: w,
                        height: 10,
                        showPercentText: false,
                        currentValue: statistic.exercise.type == ExerciseType.reps
                            ? statistic.reps
                            : statistic.duration.inMinutes,
                        maxValue: statistic.exercise.type == ExerciseType.reps
                            ? totalReps
                            : totalDuration.inMinutes,
                        backgroundColor: AppColors.surface,
                        progressColor: statistic.exercise.muscleGroup.color,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50,
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    statistic.exercise.type == ExerciseType.reps
                        ? statistic.reps.toString()
                        : Utils.durationToString(
                            statistic.duration,
                            showSeconds: false,
                            showZeroHour: true,
                          ),
                    style: TextStyle(color: AppColors.success),
                  ),
                  Text(statistic.exercise.type == ExerciseType.reps ? 'reps' : 'hh:mm'),
                ],
              ),
            ),
            Icon(Utils.iconForward, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}
