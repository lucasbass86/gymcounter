import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListTargetsPage extends StatelessWidget {
  static const String routeName = 'ListTargetsPage';
  const ListTargetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GymProvider targetProvider = Provider.of<GymProvider>(context);
    List<Target> targets = targetProvider.targets.length > Preferences.recordsForGraphics
        ? targetProvider.targets.getRange(0, Preferences.recordsForGraphics).toList()
        : targetProvider.targets;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Objetivos')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _graphic(targets),
            20.h,
            _headerTargets(context, targetProvider),
            10.h,
            _targets(targets),
          ],
        ),
      ),
    );
  }

  Widget _graphic(List<Target> targets) {
    final Color graphicColor = Colors.lime[300]!;
    List<CartesianSeries<Target, dynamic>> series = [
      AreaSeries(
        dataSource: targets,
        xValueMapper: (Target target, index) =>
            Utils.dateEnglishToSpanish(target.date, shortYear: true),
        yValueMapper: (Target target, index) => Utils.getPercent(target.value, target.target),
        enableTrackball: true,
        enableTooltip: true,
        markerSettings: MarkerSettings(isVisible: true, color: graphicColor),
        name: 'Porcentaje',
        borderColor: graphicColor,
        borderWidth: 3,
        gradient: LinearGradient(
          colors: [
            graphicColor.withAlpha((255 * 0.4).toInt()),
            graphicColor.withAlpha((255 * 0.0).toInt()),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderDrawMode: BorderDrawMode.top,
        sortFieldValueMapper: (datum, index) => datum.date,
        sortingOrder: SortingOrder.ascending,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Evolución', style: TextStyle(fontSize: 17, color: Colors.white)),
            Text(
              'Últimos ${targets.length > Preferences.recordsForGraphics ? Preferences.recordsForGraphics : targets.length}',
              style: TextStyle(color: AppColors.success),
            ),
          ],
        ),
        10.h,
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(labelRotation: 30),
            primaryYAxis: NumericAxis(),
            series: series,
            tooltipBehavior: TooltipBehavior(enable: true, shouldAlwaysShow: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              enableSelectionZooming: true,
              enableMouseWheelZooming: true,
              enablePanning: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerTargets(BuildContext context, GymProvider targetProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Objetivos', style: TextStyle(fontSize: 17, color: Colors.white)),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, ListPage.routeName, arguments: targetProvider.targets),
          child: Text('Ver todo', style: TextStyle(color: AppColors.success)),
        ),
      ],
    );
  }

  Widget _targets(List<Target> targets) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: targets.length,
        itemBuilder: (context, index) {
          return TargetWidget(target: targets[index]);
        },
      ),
    );
  }
}
