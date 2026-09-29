import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticsCardsWidget extends StatelessWidget {
  final GymProvider gymProvider;
  final List<Workout> workouts;
  final HistoryMode mode;
  final DateTime date;
  const StatisticsCardsWidget({
    super.key,
    required this.gymProvider,
    required this.workouts,
    required this.mode,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Duration duration = workouts.fold(
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
    int totalReps = workouts.fold(0, (p1, e1) => p1 + e1.totalReps);
    String previousTitle = '';

    List<Workout> prevsWorkouts = [];
    switch (mode) {
      case HistoryMode.day:
        previousTitle = '';
        break;
      case HistoryMode.week:
        prevsWorkouts = gymProvider.getWorkoutsByHistory(mode, Utils.previousWeekSameDay(date));
        previousTitle = 'Ant.';
        break;
      case HistoryMode.month:
        prevsWorkouts = gymProvider.getWorkoutsByHistory(mode, Utils.getPreviousMonth(date));
        previousTitle = Utils.monthName(Utils.getPreviousMonth(date).month, isSort: true);
        break;
      case HistoryMode.year:
        prevsWorkouts = gymProvider.getWorkoutsByHistory(mode, Utils.getPreviousYear(date));
        previousTitle = (date.year - 1).toString();
        break;
    }
    final int percentWorkouts = Utils.getPercent(prevsWorkouts.length, workouts.length).toInt();
    final Duration prevDuration = prevsWorkouts.fold(
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
    final int percentTime = Utils.getPercent(prevDuration.inMinutes, duration.inMinutes).toInt();
    final int prevTotalReps = prevsWorkouts.fold(0, (p1, e1) => p1 + e1.totalReps);
    final int percentReps = Utils.getPercent(prevTotalReps, totalReps).toInt();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _card(
            icon: Utils.iconFire,
            color: Colors.orange,
            quantity: totalReps,
            subtitle: 'Repeticiones',
            percent: percentReps,
            previous: previousTitle,
          ),
          _card(
            icon: Utils.iconStatistics,
            color: AppColors.success,
            quantity: workouts.length,
            subtitle: 'Entrenamientos',
            percent: percentWorkouts,
            previous: previousTitle,
          ),
          _card(
            icon: Utils.iconTimer,
            color: AppColors.primary,
            duration: duration,
            subtitle: 'Tiempo total',
            percent: percentTime,
            previous: previousTitle,
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required Color color,
    int? quantity,
    Duration? duration,
    required String subtitle,
    required int percent,
    required String previous,
  }) {
    IconData arrow = percent > 0 ? Utils.iconUP : Utils.iconDown;
    Color percentColor = percent > 0 ? AppColors.success : AppColors.warning;
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(
                height: 50,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: quantity != null
                      ? CountUp(
                          value: quantity,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : CountUpDuration(
                          duration: duration!,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              Text(subtitle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(arrow, color: percentColor),
                      CountUp(
                        value: percent,
                        style: TextStyle(color: percentColor),
                      ),
                      Text('%', style: TextStyle(color: percentColor)),
                    ],
                  ),
                  Text('vs $previous'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
