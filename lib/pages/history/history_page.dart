import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = 'HistoryPage';
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _StatiHistorytate();
}

class _StatiHistorytate extends State<HistoryPage> {
  late GymProvider gymProvider;
  DateTime date = DateTime.now();
  HistoryMode mode = Utils.getHistoryModeByIndex(Preferences.indexTabHistory);
  List<ExerciseSet> exercises = [];
  int totalReps = 0;
  Duration totalTime = Duration();
  late List<Workout> workouts = [];

  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context, listen: false);
    workouts = gymProvider.getWorkoutsByHistory(mode, date)
      ..sort((a, b) => b.date.compareTo(a.date));
    exercises = workouts.expand((w) => w.exercisesSet).toList();
    totalReps = exercises.fold(
      0,
      (p1, exercise) => p1 + exercise.sets.fold(0, (p2, set) => p2 + set.reps),
    );
    List<Duration> times = exercises
        .expand((e) => e.sets.where((s) => s.time != null))
        .map((t) => t.time!)
        .toList();
    totalTime = Utils.acumularDurations(times);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          20.h,
          HistoryModesWidget(
            mode: mode,
            onTap: (value) {
              Preferences.indexTabHistory = Utils.getIndexByHistoryMode(value);
              setState(() => mode = value);
            },
          ),
          20.h,
          HistoryFilterWidget(
            mode: mode,
            date: date,
            onChange: (value) => setState(() => date = value),
          ),
          20.h,
          _exercises(),
          _total(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Historial', style: TextStyle(fontSize: 20, color: Colors.white)),
        Row(
          spacing: 10,
          children: [
            IconButton(
              tooltip: 'Mostrar todo',
              onPressed: () {
                List<Workout> workouts = gymProvider.workouts
                  ..sort((a, b) => b.date.compareTo(a.date));
                Navigator.pushNamed(context, ListPage.routeName, arguments: [workouts, false]);
              },
              icon: Icon(Utils.iconDumbbell),
            ),
            IconButton(
              tooltip: 'Elegir fecha',
              onPressed: () async {
                final resp = await showDate(context, initialDate: date);
                if (resp != null) {
                  setState(() => date = resp);
                }
              },
              icon: Icon(Utils.iconCalendar),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: !Utils.isToday(date)
                  ? IconButton(
                      tooltip: 'Borrar filtro',
                      onPressed: () => setState(() => date = DateTime.now()),
                      icon: Icon(Utils.iconDelete, key: const ValueKey('icono')),
                    )
                  : const SizedBox.shrink(key: ValueKey('vacio')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _total() {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, WorkoutsListPage.routeName, arguments: [mode, date]),
      child: Card(
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Workouts'),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CountUp(
                          value: workouts.length,
                          style: TextStyle(color: AppColors.success),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 80, color: AppColors.divider),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Repeticiones'),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CountUp(
                          value: totalReps,
                          style: TextStyle(color: AppColors.success),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 80, color: AppColors.divider),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tiempo total'),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CountUpDuration(
                          duration: totalTime,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exercises() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        itemBuilder: (BuildContext context, int index) =>
            RecentExerciseWidget(set: exercises[index], workout: workouts[index]),
      ),
    );
  }
}
