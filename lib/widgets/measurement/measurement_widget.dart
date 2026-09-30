import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';

class MeasurementWidget extends StatelessWidget {
  final Measurement measurement;
  const MeasurementWidget({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    WeightProvider weightProvider = Provider.of(context, listen: false);
    double imc = Utils.calcularIMC(height: Preferences.height, weight: measurement.weight);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Utils.dateEnglishToSpanish(measurement.date)),
            Text(
              '${measurement.weight.toStringAsFixed(2)} kg',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                Icon(_icon(imc), color: _color(imc)),
                Text('${imc.toStringAsFixed(1)} IMC', style: TextStyle(color: _color(imc))),
                _menu(weightProvider),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> _menu(WeightProvider weightProvider) {
    return PopupMenuButton(
      icon: Icon(Utils.iconMenu, color: AppColors.subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      constraints: BoxConstraints(maxWidth: 70),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: IconButton(
              onPressed: () async {
                final resp = await showAddWeight(context, measurement: measurement);
                if (resp[0]) {
                  Measurement newMeasurement = Measurement(
                    id: measurement.id,
                    weight: resp[2],
                    date: resp[1],
                  );
                  bool ok = weightProvider.updateWeight(newMeasurement);
                  if (ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Peso modificado'));
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(Utils.snackBar('Algo ha fallado...', isBad: true));
                    }
                  }
                }
              },
              icon: Icon(Utils.iconEdit),
            ),
          ),
          PopupMenuItem(
            child: IconButton(
              onPressed: () async {
                final resp = await showMessage(
                  context: context,
                  message: '¿Borrar registro?',
                  cancel: true,
                );
                if (resp && context.mounted) {
                  weightProvider.removeWeight(measurement);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Registro borrado'));
                }
              },
              icon: Icon(Utils.iconDelete, color: AppColors.error),
            ),
          ),
        ];
      },
    );
  }

  IconData _icon(double imc) {
    if (imc < 18.5) return Utils.iconDown;
    if (imc < 24.9) return Utils.iconEquals;
    if (imc < 29.9) return Utils.iconUP;
    return Utils.iconObesity;
  }

  Color _color(double imc) {
    if (imc < 18.5) return Colors.blue;
    if (imc < 24.9) return Colors.green;
    if (imc < 29.9) return Colors.orange;
    return Colors.red;
  }
}
