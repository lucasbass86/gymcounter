import 'package:flutter/material.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticsListExercisesWidget extends StatelessWidget {
  final List<ExerciseStatistics> statistics;
  const StatisticsListExercisesWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final int totalReps = statistics.length > 5
        ? statistics.getRange(0, 5).fold(0, (p1, e1) => p1 + e1.reps)
        : statistics.fold(0, (p1, e1) => p1 + e1.reps);
    final Duration totalDuration = statistics.length > 5
        ? statistics.getRange(0, 5).fold(Duration.zero, (p1, e1) => p1 + e1.duration)
        : statistics.fold(Duration.zero, (p1, e1) => p1 + e1.duration);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top 5', style: TextStyle(color: Colors.white, fontSize: 19)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    StatisticsListPage.routeName,
                    arguments: statistics,
                  ),
                  child: Text(
                    'Ver todos',
                    style: TextStyle(color: AppColors.success, fontSize: 15),
                  ),
                ),
              ],
            ),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: statistics.length > 5 ? 5 : statistics.length,
              itemBuilder: (BuildContext context, int index) {
                return StatisticsExerciseWidget(
                  statistic: statistics[index],
                  totalReps: totalReps,
                  totalDuration: totalDuration,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
