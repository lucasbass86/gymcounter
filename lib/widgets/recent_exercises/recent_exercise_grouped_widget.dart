import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/graphic_models.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class RecentExerciseGroupedWidget extends StatelessWidget {
  final GraphicExerciseStatistics exercise;
  const RecentExerciseGroupedWidget({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: exercise.workouts.length,
              itemBuilder: (context, index) {
                return WorkoutWidget(workout: exercise.workouts[index]);
              },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Image.asset(exercise.exercise.image, width: 50, height: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.exercise.name, style: TextStyle(color: Colors.white)),
                            Text(
                              exercise.workouts.length == 1
                                  ? '1 entrenamiento'
                                  : '${exercise.workouts.length} entrenamientos',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        if (exercise.exercise.type == ExerciseType.reps)
                          Text(
                            '${exercise.totalReps} reps',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700),
                          ),
                        if (exercise.exercise.type == ExerciseType.time)
                          Text(
                            Utils.durationToString(exercise.totalTime),
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
