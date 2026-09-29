import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticsListPage extends StatelessWidget {
  static const String routeName = 'StatisticsListPage';
  const StatisticsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ExerciseStatistics> statistics =
        ModalRoute.of(context)!.settings.arguments as List<ExerciseStatistics>;
    final int totalReps = statistics.fold(0, (p1, e1) => p1 + e1.reps);
    final Duration totalDuration = statistics.fold(Duration.zero, (p1, e1) => p1 + e1.duration);
    List<ExerciseStatistics> byReps =
        statistics.where((e) => e.exercise.type == ExerciseType.reps).toList()
          ..sort((a, b) => b.reps.compareTo(a.reps));
    List<ExerciseStatistics> byTime =
        statistics.where((e) => e.exercise.type == ExerciseType.time).toList()
          ..sort((a, b) => b.duration.compareTo(a.duration));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text('Resumen ejercicios'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 30,
            children: [
              _statisticsList(byReps, totalReps, totalDuration),
              _statisticsList(byTime, totalReps, totalDuration),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statisticsList(List<ExerciseStatistics> data, int totalReps, Duration totalDuration) {
    if (data.isEmpty) return SizedBox.shrink();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(
                  data[0].exercise.type == ExerciseType.reps ? Utils.iconReps : Utils.iconTimer,
                  color: AppColors.success,
                  size: 40,
                ),
                Text(
                  'Por ${data[0].exercise.type == ExerciseType.reps ? 'repetición' : 'tiempo'}',
                  style: TextStyle(fontSize: 23, color: AppColors.primary),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                data[0].exercise.type == ExerciseType.reps
                    ? totalReps.toString()
                    : Utils.durationToString(totalDuration, showSeconds: false, showZeroHour: true),
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
        10.h,
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: StatisticsExerciseWidget(
                statistic: data[index],
                totalReps: totalReps,
                totalDuration: totalDuration,
              ),
            );
          },
        ),
      ],
    );
  }
}
