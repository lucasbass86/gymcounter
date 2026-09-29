import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/models/graphic_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExercisePage extends StatefulWidget {
  static const String routeName = 'ExercisePage';
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late GymProvider gymProvider = Provider.of<GymProvider>(context);
  late Exercise exercise;
  List<StatisticsOptions> statisticsOptions = [...StatisticsOptions.values];
  StatisticsOptions selectedStatistics = StatisticsOptions.repetitions;
  List<SetResult> sets = [];
  int totalReps = 0;
  Workout? bestSetWorkout;
  int maxReps = 0;
  Workout? bestWorkout;
  int? maxRepsBestWorkout;
  late Workout workoutMaxSets;
  int maxSets = 0;
  //DURACIONES
  Duration? totalDuration;
  Workout? bestWorkoutTime;
  Duration? bestTime;

  Workout? bestWorkoutSetTime;
  Duration? bestSetTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //ELIMINAR OPCIONES DE ESTADISTICAS DEL TIPO DE EJERCICIO:
      if (exercise.type == ExerciseType.reps) {
        statisticsOptions.remove(StatisticsOptions.time);
      } else {
        statisticsOptions.remove(StatisticsOptions.repetitions);
        selectedStatistics = StatisticsOptions.time;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final idExercise = ModalRoute.of(context)!.settings.arguments as String;
    exercise = gymProvider.exercises.firstWhere((e) => e.id == idExercise);

    //REPETICIONES TOTALES Y SERIES TOTALES
    sets = gymProvider.setsOfExercise(exercise);
    totalReps = gymProvider.totalRepsFromExercise(exercise);

    //MAX REPS
    final result = gymProvider.getWorkoutMaxRepsForExercise(exercise);
    bestSetWorkout = result.workout;
    maxReps = result.reps;

    //MAYOR VOLUMEN
    bestWorkout = gymProvider.getBestWorkoutForExercise(exercise);
    if (bestWorkout != null) {
      maxRepsBestWorkout = gymProvider.totalRepsFromExerciseFromWorkout(bestWorkout!, exercise);
    }

    //MAS SERIES
    workoutMaxSets = gymProvider.getBestWorkoutForExerciseSets(exercise);
    maxSets = gymProvider.totalSetsWorkoutExercise(workoutMaxSets, exercise);

    //DURACIONES
    if (exercise.type == ExerciseType.time) {
      totalDuration = gymProvider.getTotalTimeForExercise(exercise);
      final resultTime = gymProvider.getBestWorkoutTimeForExercise(exercise);
      bestWorkoutTime = resultTime.workout;
      bestTime = resultTime.time;
      bestWorkoutSetTime = gymProvider.getWorkoutWithBestSetTimeForExercise(exercise);
      bestSetTime = gymProvider.getBestSetTime(bestWorkoutSetTime!, exercise);
    }

    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              _notes(),
              _generalStatistics(),
              _personalRecors(),
              _history(),
              _graphic(),
              ButtonSaveWidget(
                onTap: () =>
                    Navigator.pushNamed(context, WorkoutPage.routeName, arguments: exercise),
                title: 'Iniciar workout',
                backColor: AppColors.success,
                icon: Utils.iconPlay,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(exercise.name)),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, NewExercisePage.routeName, arguments: exercise),
          child: Row(
            spacing: 5,
            children: [
              Icon(Utils.iconEdit, color: AppColors.success),
              Text('Editar', style: TextStyle(color: AppColors.success)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => showImage(context, exercise.muscleGroup.assetName),
              child: Image.asset(exercise.muscleGroup.assetName, width: 20, height: 20),
            ),
            Text(exercise.muscleGroup.displayName),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => showImage(context, exercise.image),
            child: Image.asset(exercise.image, width: 150, height: 150),
          ),
        ),
      ],
    );
  }

  Widget _notes() {
    if (exercise.note.isEmpty) return SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(Utils.iconInfo),
                Text('Notas', style: TextStyle(color: Colors.white)),
              ],
            ),
            20.h,
            Text(exercise.note),
          ],
        ),
      ),
    );
  }

  Widget _generalStatistics() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Utils.iconStatistics),
                  Text('Estadísticas generales', style: TextStyle(color: Colors.white)),
                ],
              ),
              20.h,
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (exercise.type == ExerciseType.reps)
                      StatisticCardNumberWidget(
                        icon: Utils.iconStatistics,
                        color: AppColors.success,
                        value: totalReps,
                        subtitle: 'Total reps',
                      ),
                    if (exercise.type == ExerciseType.reps)
                      Container(width: 1, height: 100, color: AppColors.divider),
                    StatisticCardNumberWidget(
                      icon: Utils.iconCalendar,
                      color: AppColors.primary,
                      value: sets.length,
                      subtitle: 'Series',
                    ),
                    Container(width: 1, height: 100, color: AppColors.divider),
                    StatisticCardDurationWidget(
                      icon: Utils.iconStatistics,
                      color: AppColors.highlight,
                      value: totalDuration ?? Duration(hours: 0),
                      subtitle: 'Tiempo total',
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

  Widget _personalRecors() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Utils.iconBest),
                  Text('Mejores marcas', style: TextStyle(color: Colors.white)),
                ],
              ),
              20.h,
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (exercise.type == ExerciseType.reps)
                      _personalRecordCard(
                        mainTitle: 'Max reps',
                        quantity: maxReps,
                        quantitySuffix: 'reps',
                        subtitle: bestSetWorkout != null
                            ? Utils.shortdateEnglishToSpanish(bestSetWorkout!.date.toString())
                            : 'Sin reps',
                        workout: bestSetWorkout,
                      ),
                    if (exercise.type == ExerciseType.time)
                      _personalRecordCard(
                        mainTitle: 'Max tiempo',
                        duration: bestSetTime,
                        quantitySuffix: '',
                        subtitle: bestWorkoutSetTime != null
                            ? Utils.shortdateEnglishToSpanish(bestWorkoutSetTime!.date.toString())
                            : 'Sin tiempo',
                        workout: bestWorkoutSetTime,
                      ),
                    Container(width: 1, height: 100, color: AppColors.divider),
                    if (exercise.type == ExerciseType.reps)
                      _personalRecordCard(
                        mainTitle: 'Mayor volumen',
                        quantity: maxRepsBestWorkout,
                        quantitySuffix: 'reps',
                        subtitle: bestWorkout != null
                            ? Utils.shortdateEnglishToSpanish(bestWorkout!.date.toString())
                            : 'mirar',
                        workout: bestWorkout,
                      ),
                    if (exercise.type == ExerciseType.time)
                      _personalRecordCard(
                        mainTitle: 'Mayor volumen',
                        duration: bestTime!,
                        quantitySuffix: '',
                        subtitle: bestWorkoutTime != null
                            ? Utils.shortdateEnglishToSpanish(bestWorkoutTime!.date.toString())
                            : 'mirar',
                        workout: bestWorkoutTime,
                      ),
                    Container(width: 1, height: 100, color: AppColors.divider),
                    _personalRecordCard(
                      mainTitle: 'Más series',
                      quantity: maxSets,
                      quantitySuffix: 'series',
                      subtitle: Utils.shortdateEnglishToSpanish(workoutMaxSets.date.toString()),
                      workout: workoutMaxSets,
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

  Widget _personalRecordCard({
    required String mainTitle,
    int? quantity,
    Duration? duration,
    required String quantitySuffix,
    required String subtitle,
    Workout? workout,
  }) {
    return GestureDetector(
      onTap: workout != null
          ? () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: workout)
          : null,
      child: SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(mainTitle),
              Row(
                spacing: 5,
                children: [
                  if (quantity != null)
                    CountUp(
                      value: quantity,
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (duration != null)
                    CountUpDuration(
                      duration: duration,
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  Text(
                    quantitySuffix,
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _history() {
    List<Workout> workouts = gymProvider.workouts
        .where((w) => w.exercisesSet.any((e) => e.exercise.id == exercise.id))
        .toList();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    if (workouts.length >= 5) workouts = workouts.getRange(0, 5).toList();
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Utils.iconHistory),
                      Text('Historial reciente', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ExerciseHistoryPage.routeName,
                      arguments: exercise,
                    ),
                    child: Text('Ver todo', style: TextStyle(color: AppColors.success)),
                  ),
                ],
              ),
              Divider(color: AppColors.divider),
              ExerciseHistoryWidget(exercise: exercise, workouts: workouts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _graphic() {
    List<Workout> workouts = gymProvider.workouts
        .where((w) => w.exercisesSet.any((e) => e.exercise.id == exercise.id))
        .toList();
    workouts.sort((a, b) => a.date.compareTo(b.date));
    List<CartesianSeries<dynamic, dynamic>> series = [];
    switch (selectedStatistics) {
      case StatisticsOptions.workout:
        final Map<DateTime, int> grouped = {};
        for (final workout in workouts) {
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          grouped[day] = (grouped[day] ?? 0) + 1;
        }

        List<GraphicExerciseWorkouts> data =
            grouped.entries
                .map(
                  (entry) => GraphicExerciseWorkouts(
                    exercise: exercise,
                    date: entry.key,
                    workouts: entry.value,
                  ),
                )
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        series = [
          AreaSeries<GraphicExerciseWorkouts, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.workouts,
            enableTrackball: true,
            enableTooltip: true,
            markerSettings: MarkerSettings(isVisible: true, color: AppColors.success),
            name: 'Repeticiones',
            borderColor: AppColors.success,
            borderWidth: 3,
            gradient: LinearGradient(
              colors: [
                AppColors.success.withAlpha((255 * 0.4).toInt()),
                AppColors.success.withAlpha((255 * 0.0).toInt()),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderDrawMode: BorderDrawMode.top,
            sortFieldValueMapper: (datum, index) => datum.date,
            sortingOrder: SortingOrder.ascending,
          ),
        ];

        break;
      case StatisticsOptions.time:
        final Map<DateTime, Duration> grouped = {};

        for (final workout in workouts) {
          for (final exerciseSet in workout.exercisesSet) {
            if (exerciseSet.exercise.id != exercise.id) {
              continue;
            }

            for (final set in exerciseSet.sets) {
              final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
              final time = set.time!;
              grouped[day] = (grouped[day] ?? Duration.zero) + time;
            }
          }
        }

        List<GraphicExerciseTime> data =
            grouped.entries
                .map(
                  (entry) =>
                      GraphicExerciseTime(exercise: exercise, time: entry.value, date: entry.key),
                )
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));

        series = [
          AreaSeries<GraphicExerciseTime, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.time.inMinutes,
            enableTrackball: true,
            enableTooltip: true,
            markerSettings: MarkerSettings(isVisible: true, color: AppColors.primary),
            name: 'Minutos',
            borderColor: AppColors.primary,
            borderWidth: 3,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withAlpha((255 * 0.4).toInt()),
                AppColors.primary.withAlpha((255 * 0.0).toInt()),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderDrawMode: BorderDrawMode.top,
            sortFieldValueMapper: (datum, index) => datum.date,
            sortingOrder: SortingOrder.ascending,
          ),
        ];
        break;
      case StatisticsOptions.repetitions:
        final List<GraphicExerciseReps> result = [];
        for (final workout in workouts) {
          for (final exerciseSet in workout.exercisesSet) {
            if (exerciseSet.exercise.id != exercise.id) {
              continue;
            }

            for (final set in exerciseSet.sets) {
              result.add(
                GraphicExerciseReps(
                  exercise: exercise,
                  reps: set.reps,
                  weight: set.weight,
                  date: workout.date,
                ),
              );
            }
          }
        }
        final Map<DateTime, GraphicExerciseReps> grouped = {};

        for (final item in result) {
          final day = DateTime(item.date.year, item.date.month, item.date.day);

          if (grouped.containsKey(day)) {
            final current = grouped[day]!;

            grouped[day] = GraphicExerciseReps(
              exercise: item.exercise,
              reps: current.reps + item.reps,
              weight: item.weight,
              date: day,
            );
          } else {
            grouped[day] = GraphicExerciseReps(
              exercise: item.exercise,
              reps: item.reps,
              weight: item.weight,
              date: day,
            );
          }
        }

        final data = grouped.values.toList();

        data.sort((a, b) => a.date.compareTo(b.date));

        bool hasWeight = data.any((d) => d.weight != 0);

        series = [
          AreaSeries<GraphicExerciseReps, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.reps,
            enableTrackball: true,
            enableTooltip: true,
            markerSettings: MarkerSettings(isVisible: true, color: AppColors.warning),
            name: 'Repeticiones',
            borderColor: AppColors.warning,
            borderWidth: 3,
            gradient: LinearGradient(
              colors: [
                AppColors.warning.withAlpha((255 * 0.4).toInt()),
                AppColors.warning.withAlpha((255 * 0.0).toInt()),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderDrawMode: BorderDrawMode.top,
            sortFieldValueMapper: (datum, index) => datum.date,
            sortingOrder: SortingOrder.ascending,
          ),
          if (hasWeight)
            AreaSeries<GraphicExerciseReps, dynamic>(
              dataSource: data,
              xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
              yValueMapper: (item, _) => item.weight,
              enableTrackball: true,
              enableTooltip: true,
              markerSettings: MarkerSettings(isVisible: true, color: AppColors.highlight),
              name: 'Peso',
              borderColor: AppColors.highlight,
              borderWidth: 3,
              gradient: LinearGradient(
                colors: [
                  AppColors.highlight.withAlpha((255 * 0.4).toInt()),
                  AppColors.highlight.withAlpha((255 * 0.0).toInt()),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderDrawMode: BorderDrawMode.top,
              sortFieldValueMapper: (datum, index) => datum.date,
              sortingOrder: SortingOrder.ascending,
            ),
        ];
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(Utils.iconGraphic),
                      Text('Progreso', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: DropdownButton(
                      value: selectedStatistics,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(20),
                      items: statisticsOptions
                          .map(
                            (val) => DropdownMenuItem(
                              value: val,
                              child: Text(val.displayName, style: TextStyle(fontSize: 13)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => selectedStatistics = value!),
                    ),
                  ),
                ],
              ),
              20.h,
              SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(labelRotation: 25),
                  primaryYAxis: NumericAxis(minimum: 0, interval: 10),
                  tooltipBehavior: TooltipBehavior(enable: true, shouldAlwaysShow: true),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enableDoubleTapZooming: true,
                    enableSelectionZooming: true,
                    enableMouseWheelZooming: true,
                    enablePanning: true,
                  ),
                  series: series,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
