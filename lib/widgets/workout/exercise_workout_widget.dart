import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class WorkoutWidget extends StatelessWidget {
  final Workout workout;
  final bool isCard;
  const WorkoutWidget({super.key, required this.workout, this.isCard = true});

  @override
  Widget build(BuildContext context) {
    int sets = workout.exercisesSet.fold(0, (p1, exercise) => p1 + exercise.sets.length);
    int totalReps = workout.exercisesSet.fold(
      0,
      (p1, exercise) => p1 + exercise.sets.fold(0, (p2, set) => p2 + set.reps),
    );
    return BounceableWidget(
      onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: workout),
      child: Card(
        elevation: isCard ? 2 : 0,
        child: Container(
          padding: EdgeInsets.all(isCard ? 16 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 30,
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
                        workout.exercisesSet.length == 1
                            ? '1 ejercicio'
                            : '${workout.exercisesSet.length} ejercicios',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(sets == 1 ? '1 set' : '$sets sets'),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 3,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Utils.durationToString(workout.time, showZeroHour: true),
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Text(totalReps.toString(), style: TextStyle(color: Colors.white)),
                          Text('reps'),
                        ],
                      ),
                    ],
                  ),
                  Icon(Utils.iconForward, color: AppColors.success, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
