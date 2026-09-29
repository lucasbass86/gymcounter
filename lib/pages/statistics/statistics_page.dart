import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticsPage extends StatefulWidget {
  static const String routeName = 'StatisticsPage';
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late GymProvider gymProvider;
  DateTime date = DateTime.now();
  HistoryMode mode = Utils.getHistoryModeByIndex(Preferences.indexTabStatistics);
  StatisticsOptions statisticsOptions = StatisticsOptions.repetitions;
  List<Workout> workouts = [];
  List<ExerciseSet> exercisesSets = [];
  List<Exercise> exercises = [];
  List<ExerciseStatistics> statistics = [];

  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of(context);
    workouts = gymProvider.getWorkoutsByHistory(mode, date);
    exercisesSets = gymProvider.getExerciseSetsByHistory(mode, date);
    exercises = exercisesSets.map((e) => e.exercise).toSet().toList();
    statistics = [];
    for (Exercise ex in exercises) {
      ExerciseStatistics statistic = ExerciseStatistics(
        exercise: ex,
        reps: exercisesSets
            .where((e) => e.exercise.id == ex.id)
            .fold(0, (p1, e1) => p1 + e1.sets.fold(0, (p2, e2) => p2 + e2.reps)),
        duration: exercisesSets
            .where((e) => e.exercise.id == ex.id)
            .fold(
              Duration.zero,
              (p1, e1) =>
                  p1 +
                  e1.sets.fold(
                    Duration.zero,
                    (p2, e2) => p2 + (e2.time != null ? e2.time! : Duration.zero),
                  ),
            ),
      );
      statistics.add(statistic);
    }
    statistics.sort((a, b) => b.reps.compareTo(a.reps));
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HistoryModesWidget(
              mode: mode,
              withDay: false,
              onTap: (value) {
                Preferences.indexTabStatistics = Utils.getIndexByHistoryMode(value);
                setState(() => mode = value);
              },
            ),
            20.h,
            _dateFilter(),
            20.h,
            StatisticsCardsWidget(
              gymProvider: gymProvider,
              workouts: workouts,
              mode: mode,
              date: date,
            ),
            20.h,
            StatisticsGraphicWidget(
              workouts: workouts,
              statisticsOptions: statisticsOptions,
              onChange: (value) => setState(() => statisticsOptions = value),
            ),
            20.h,
            StatisticsListExercisesWidget(statistics: statistics),
          ],
        ),
      ),
    );
  }

  Widget _dateFilter() {
    String header = '', filter = '';
    switch (mode) {
      case HistoryMode.day:
        break;
      case HistoryMode.week:
        header = 'Resumen semanal';
        filter = Utils.week(date, isSort: true);
        break;
      case HistoryMode.month:
        header = 'Resumen mensual';
        filter = Utils.monthName(date.month);
        break;
      case HistoryMode.year:
        header = 'Resumen anual';
        filter = date.year.toString();
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(header, style: TextStyle(fontSize: 17, color: Colors.white)),
        Row(
          spacing: 10,
          children: [
            BounceableWidget(
              scaleFactorOnTap: 1.2,
              onTap: () {
                switch (mode) {
                  case HistoryMode.day:
                    date = date.subtract(Duration(days: 1));
                    break;
                  case HistoryMode.week:
                    date = Utils.previousWeekSameDay(date);
                    break;
                  case HistoryMode.month:
                    date = Utils.getPreviousMonth(date);
                    break;
                  case HistoryMode.year:
                    date = Utils.getPreviousYear(date);
                    break;
                }
                setState(() {});
              },
              child: Icon(Utils.iconBack, color: AppColors.success),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(filter, style: TextStyle(color: AppColors.success)),
            ),
            BounceableWidget(
              scaleFactorOnTap: 1.2,
              onTap: () {
                switch (mode) {
                  case HistoryMode.day:
                    date = date.subtract(Duration(days: -1));
                    break;
                  case HistoryMode.week:
                    date = Utils.previousWeekSameDay(date, isNext: true);
                    break;
                  case HistoryMode.month:
                    date = Utils.getPreviousMonth(date, isNext: true);
                    break;
                  case HistoryMode.year:
                    date = Utils.getPreviousYear(date, isNext: true);
                    break;
                }
                setState(() {});
              },
              child: Icon(Utils.iconForward, color: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }
}
