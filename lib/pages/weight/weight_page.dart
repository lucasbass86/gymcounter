import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/helper.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightPage extends StatefulWidget {
  static const String routeName = 'WeightPage';
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  late WeightProvider weightProvider;
  List<Measurement> weights = [];
  @override
  Widget build(BuildContext context) {
    weightProvider = Provider.of<WeightProvider>(context);
    weights = weightProvider.weights;
    weights.sort((a, b) => b.date.compareTo(a.date));
    weights = weights.length > Preferences.recordsForGraphics
        ? weights.getRange(0, Preferences.recordsForGraphics).toList()
        : weights;
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton: _fab(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _graphic(),
            20.h,
            _headerWeight(context),
            10.h,
            Expanded(child: _measurements()),
          ],
        ),
      ),
    );
  }

  Widget _headerWeight(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Mediciones', style: TextStyle(fontSize: 17, color: Colors.white)),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, ListPage.routeName, arguments: weightProvider.weights),
          child: Text('Ver todo', style: TextStyle(color: AppColors.success)),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Control de peso')),
      actions: [
        IconButton(
          onPressed: () async {
            final resp = await showInput(
              context,
              'Indica tu altura (cm)',
              inputType: TextInputType.numberWithOptions(),
              value: Preferences.height.toStringAsFixed(2),
            );
            if (resp[0] && context.mounted) {
              Preferences.height = double.parse(resp[1]);
              ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Altura guardada'));
              setState(() {});
            }
          },
          icon: Icon(Utils.iconHeight),
        ),
        IconButton(onPressed: () => modalIMCInfo(context), icon: Icon(Utils.iconInfo)),
      ],
    );
  }

  Widget _fab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final resp = await showAddWeight(context);
        if (resp[0] && context.mounted) {
          Helper.addWeight(context, resp[1], resp[2]);
        }
      },
      child: Icon(Utils.iconAdd),
    );
  }

  Widget _graphic() {
    //CARGAR UN MAXIMO DE 50.
    List<Measurement> values = weightProvider.weights.length > Preferences.recordsForGraphics
        ? weightProvider.weights.getRange(0, Preferences.recordsForGraphics).toList()
        : weightProvider.weights;
    List<CartesianSeries<Measurement, dynamic>> series = [
      AreaSeries(
        dataSource: values,
        xValueMapper: (Measurement measurement, index) =>
            Utils.dateEnglishToSpanish(measurement.date, shortYear: true),
        yValueMapper: (Measurement measurement, index) => measurement.weight,
        enableTrackball: true,
        enableTooltip: true,
        markerSettings: MarkerSettings(isVisible: true, color: AppColors.success),
        name: 'Peso',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Evolución', style: TextStyle(fontSize: 17, color: Colors.white)),
            Text(
              'Últimos ${values.length > Preferences.recordsForGraphics ? Preferences.recordsForGraphics : values.length}',
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

  Widget _measurements() {
    if (weights.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: weights.length,
        itemBuilder: (context, index) {
          return MeasurementWidget(measurement: weights[index]);
        },
      );
    } else {
      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(Utils.iconWeight, size: 40, color: AppColors.card),
            Text('No hay mediciones guardadas'),
          ],
        ),
      );
    }
  }
}
