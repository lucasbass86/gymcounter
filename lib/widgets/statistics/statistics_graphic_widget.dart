import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/models/graphic_models.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsGraphicWidget extends StatefulWidget {
  final List<Workout> workouts;
  final StatisticsOptions statisticsOptions;
  final Function(StatisticsOptions) onChange;
  const StatisticsGraphicWidget({
    super.key,
    required this.statisticsOptions,
    required this.onChange,
    required this.workouts,
  });

  @override
  State<StatisticsGraphicWidget> createState() => _StatisticsGraphicWidgetState();
}

class _StatisticsGraphicWidgetState extends State<StatisticsGraphicWidget> {
  late GymProvider gymProvider;
  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context, listen: false);
    String title = '';
    List<CartesianSeries<dynamic, dynamic>> series = [];

    switch (widget.statisticsOptions) {
      case StatisticsOptions.workout:
        title = 'Entrenamientos por día';
        final Map<DateTime, int> grouped = {};
        for (final workout in widget.workouts) {
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          grouped[day] = (grouped[day] ?? 0) + 1;
        }

        List<GraphicStatisticsReps> data =
            grouped.entries
                .map((entry) => GraphicStatisticsReps(date: entry.key, workouts: entry.value))
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        series = [
          AreaSeries<GraphicStatisticsReps, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.workouts,
            enableTrackball: true,
            enableTooltip: true,
            markerSettings: MarkerSettings(isVisible: true, color: AppColors.success),
            name: 'Entrenamientos',
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
        title = 'Tiempo por día';
        final Map<DateTime, Duration> grouped = {};
        for (Workout workout in widget.workouts) {
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          grouped[day] =
              (grouped[day] ?? Duration.zero) + gymProvider.totalDurationFromFromWorkout(workout);
        }

        List<GraphicStatisticsDuration> data =
            grouped.entries
                .map((entry) => GraphicStatisticsDuration(date: entry.key, duration: entry.value))
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        series = [
          AreaSeries<GraphicStatisticsDuration, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.duration.inMinutes,
            enableTrackball: true,
            enableTooltip: true,
            markerSettings: MarkerSettings(isVisible: true, color: AppColors.primary),
            name: 'Tiempo',
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
        title = 'Repeticiones por día';
        final Map<DateTime, int> grouped = {};
        for (Workout workout in widget.workouts) {
          final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
          grouped[day] = (grouped[day] ?? 0) + gymProvider.totalRepsFromFromWorkout(workout);
        }

        List<GraphicStatisticsReps> data =
            grouped.entries
                .map((entry) => GraphicStatisticsReps(date: entry.key, workouts: entry.value))
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        series = [
          AreaSeries<GraphicStatisticsReps, dynamic>(
            dataSource: data,
            xValueMapper: (item, _) => Utils.dateEnglishToSpanish(item.date, shortYear: true),
            yValueMapper: (item, _) => item.workouts,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButton(
                    value: widget.statisticsOptions,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(20),
                    items: StatisticsOptions.values
                        .map(
                          (val) => DropdownMenuItem(
                            value: val,
                            child: Text(val.displayName, style: TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => widget.onChange.call(value!),
                  ),
                ),
              ],
            ),
            20.h,
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(labelRotation: 45),
                primaryYAxis: NumericAxis(minimum: 0),
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
    );
  }
}
