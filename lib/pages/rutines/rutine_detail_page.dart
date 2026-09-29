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

class RutineDetailPage extends StatelessWidget {
  static const String routeName = 'RutineDetailPage';
  RutineDetailPage({super.key});

  final ValueNotifier<StatisticsOptions> selectedStatistics = ValueNotifier<StatisticsOptions>(
    StatisticsOptions.repetitions,
  );

  @override
  Widget build(BuildContext context) {
    final GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
    Rutine rutine = ModalRoute.of(context)!.settings.arguments as Rutine;

    return Scaffold(
      appBar: _appBar(context, gymProvider, rutine),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _difficult(rutine),
            20.h,
            _name(rutine),
            20.h,
            _generalStatistics(gymProvider, rutine),
            20.h,
            _history(context, gymProvider, rutine),
            20.h,
            _exercises(rutine),
            20.h,
            _graphic(gymProvider, rutine),
            20.h,
            ButtonSaveWidget(
              onTap: () =>
                  Navigator.pushNamed(context, PlayRutinePage.routeName, arguments: rutine),
              title: 'Iniciar rutina',
              backColor: AppColors.success,
              icon: Utils.iconPlay,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, GymProvider gymProvider, Rutine rutine) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Rutina')),
      actions: [
        IconButton(
          tooltip: 'Editar',
          onPressed: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: rutine),
          icon: Icon(Utils.iconEdit),
        ),
        IconButton(
          tooltip: 'Eliminar',
          onPressed: () async {
            final resp = await showMessage(
              context: context,
              message: '¿Eliminar la rutina?',
              cancel: true,
            );
            if (resp != null && resp) {
              final ok = gymProvider.deleteRutine(rutine);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Rutina borrada'));
                Navigator.pop(context);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(Utils.snackBar('Algo ha fallado . . .', isBad: true));
                }
              }
            }
          },
          icon: Icon(Utils.iconDelete),
        ),
      ],
    );
  }

  Widget _difficult(Rutine rutine) {
    return Image.asset(rutine.difficulty.assetName, width: 200, height: 200);
  }

  Widget _name(Rutine rutine) {
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
                Text('Nombre', style: TextStyle(color: Colors.white)),
              ],
            ),
            20.h,
            Text(rutine.name),
          ],
        ),
      ),
    );
  }

  Widget _exercises(Rutine rutine) {
    rutine.exercisesSet.sort((a, b) => a.order.compareTo(b.order));
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
                  Icon(Utils.iconDumbbell),
                  Text('Ejercicios', style: TextStyle(color: Colors.white)),
                ],
              ),
              20.h,
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: rutine.exercisesSet.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExerciseSetWidget(
                    exerciseSet: rutine.exercisesSet[index],
                    onDelete: () {},
                    onUpdate: (p0) {},
                    lock: true,
                    onUp: () {},
                    onDown: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generalStatistics(GymProvider gymProvider, Rutine rutine) {
    List<Workout> workouts = gymProvider.workouts.where((w) => w.idRutine == rutine.id).toList();
    int reps = workouts.fold(0, (p1, e1) => p1 + e1.totalReps);
    Duration duration = workouts.fold(Duration.zero, (p1, e1) => p1 + e1.time);
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
                    StatisticCardNumberWidget(
                      icon: Utils.iconStatistics,
                      color: AppColors.success,
                      value: reps,
                      subtitle: 'Repeticiones',
                      duration: const Duration(seconds: 2),
                    ),
                    Container(width: 1, height: 100, color: AppColors.divider),
                    StatisticCardNumberWidget(
                      icon: Utils.iconCalendar,
                      color: AppColors.primary,
                      value: workouts.length,
                      duration: const Duration(seconds: 2),
                      subtitle: 'Workouts',
                    ),
                    Container(width: 1, height: 100, color: AppColors.divider),
                    StatisticCardDurationWidget(
                      icon: Utils.iconTimer,
                      color: AppColors.highlight,
                      value: duration,
                      subtitle: 'Tiempo total',
                      duration: const Duration(seconds: 2),
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

  Widget _history(BuildContext context, GymProvider gymProvider, Rutine rutine) {
    List<Workout> workouts = gymProvider.workouts.where((w) => w.idRutine == rutine.id).toList();
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
                  if (workouts.isNotEmpty && workouts.length > 5)
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        WorkoutsListPage.routeName,
                        arguments: rutine,
                      ),
                      child: Text('Ver todo', style: TextStyle(color: AppColors.success)),
                    ),
                ],
              ),
              Divider(color: AppColors.divider),
              if (workouts.isEmpty) _noWorkouts(),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: workouts.length,
                itemBuilder: (BuildContext context, int index) =>
                    WorkoutWidget(workout: workouts[index], isCard: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _graphic(GymProvider gymProvider, Rutine rutine) {
    return ValueListenableBuilder<StatisticsOptions>(
      valueListenable: selectedStatistics,
      builder: (_, stat, __) => _graphicContent(gymProvider, rutine, stat),
    );
  }

  Widget _graphicContent(GymProvider gymProvider, Rutine rutine, StatisticsOptions selected) {
    List<Workout> workouts = gymProvider.workouts.where((w) => w.idRutine == rutine.id).toList();
    workouts.sort((a, b) => a.date.compareTo(b.date));
    List<CartesianSeries<dynamic, dynamic>> series = [];
    List<StatisticsOptions> statisticsOptions = [...StatisticsOptions.values];
    switch (selected) {
      case StatisticsOptions.workout:
        final Map<DateTime, int> grouped = {};
        for (final workout in workouts) {
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          grouped[day] = (grouped[day] ?? 0) + 1;
        }

        List<GraphicRutineWorkouts> data =
            grouped.entries
                .map(
                  (entry) =>
                      GraphicRutineWorkouts(rutine: rutine, date: entry.key, workouts: entry.value),
                )
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        series = [
          AreaSeries<GraphicRutineWorkouts, dynamic>(
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
          if (workout.idRutine != rutine.id) continue;
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          final time = workout.time;
          grouped[day] = (grouped[day] ?? Duration.zero) + time;
        }

        List<GraphicRutineTime> data =
            grouped.entries
                .map(
                  (entry) => GraphicRutineTime(rutine: rutine, time: entry.value, date: entry.key),
                )
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));

        series = [
          AreaSeries<GraphicRutineTime, dynamic>(
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
        final List<GraphicRutineReps> result = [];
        for (final workout in workouts) {
          if (workout.idRutine != rutine.id) continue;
          for (final exerciseSet in workout.exercisesSet) {
            for (final set in exerciseSet.sets) {
              result.add(GraphicRutineReps(rutine: rutine, reps: set.reps, date: workout.date));
            }
          }
        }
        final Map<DateTime, GraphicRutineReps> grouped = {};

        for (final item in result) {
          final day = DateTime(item.date.year, item.date.month, item.date.day);

          if (grouped.containsKey(day)) {
            final current = grouped[day]!;

            grouped[day] = GraphicRutineReps(
              rutine: item.rutine,
              reps: current.reps + item.reps,
              date: day,
            );
          } else {
            grouped[day] = GraphicRutineReps(rutine: item.rutine, reps: item.reps, date: day);
          }
        }

        final data = grouped.values.toList();

        data.sort((a, b) => a.date.compareTo(b.date));

        series = [
          AreaSeries<GraphicRutineReps, dynamic>(
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
                      value: selected,
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
                      onChanged: (value) {
                        selectedStatistics.value = value!;
                      },
                    ),
                  ),
                ],
              ),
              20.h,
              if (workouts.isEmpty) _noWorkouts(),
              if (workouts.isNotEmpty)
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

  Widget _noWorkouts() {
    return Center(
      child: Column(spacing: 10, children: [Icon(Utils.iconFire), Text('No hay workouts')]),
    );
  }
}
