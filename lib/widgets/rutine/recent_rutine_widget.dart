import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class RecentRutineWidget extends StatelessWidget {
  final GymProvider gymProvider;
  const RecentRutineWidget({super.key, required this.gymProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(Utils.iconPlay),
              Text('Workout actual', style: TextStyle(fontSize: 17, color: Colors.white)),
            ],
          ),
          (gymProvider.currentWorkout == null || gymProvider.currentWorkout!.finished)
              ? NoDataWidget(title: 'No hay workout en curso')
              : _data(context),
        ],
      ),
    );
  }

  Widget _data(BuildContext context) {
    Workout? workout = gymProvider.currentWorkout!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name.isNotEmpty ? workout.name : 'Workout',
                    style: TextStyle(fontSize: 19, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    workout.exercisesSet.length == 1
                        ? '1 ejercicio'
                        : '${workout.exercisesSet.length} ejercicios',
                  ),
                ],
              ),
            ),
            Row(
              spacing: 5,
              children: [
                BounceableWidget(
                  onTap: () => Navigator.pushNamed(
                    context,
                    WorkoutPage.routeName,
                    arguments: gymProvider.currentWorkout,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.success,
                    ),
                    child: Text('Continuar', style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                Icon(Utils.iconForward),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
