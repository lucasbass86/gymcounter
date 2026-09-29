import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class RecentExerciseWidget extends StatelessWidget {
  final ExerciseSet set;
  final Workout workout;
  const RecentExerciseWidget({super.key, required this.set, required this.workout});

  @override
  Widget build(BuildContext context) {
    int totalReps = set.sets.fold(0, (previousValue, element) => previousValue + element.reps);
    List<Duration> times = set.sets.where((s) => s.time != null).map((t) => t.time!).toList();
    Duration totalTime = Utils.acumularDurations(times);
    return BounceableWidget(
      onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: workout),
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
                        Image.asset(set.exercise.image, width: 50, height: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(set.exercise.name, style: TextStyle(color: Colors.white)),
                            Text(set.sets.length == 1 ? '1 serie' : '${set.sets.length} series'),
                            Text(Utils.dateEnglishToSpanish(workout.date)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        if (set.exercise.type == ExerciseType.reps)
                          Text(
                            '$totalReps reps',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700),
                          ),
                        if (set.exercise.type == ExerciseType.time)
                          Text(
                            Utils.durationToString(totalTime),
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700),
                          ),
                        Icon(Utils.iconForward),
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
