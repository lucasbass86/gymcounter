import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:uuid/uuid.dart';

class Helper {
  static void addWeight(BuildContext context, DateTime date, double weight) {
    final WeightProvider weightProvider = Provider.of(context, listen: false);
    Measurement measurement = Measurement(id: Uuid().v4(), weight: weight, date: date);
    bool ok = weightProvider.addWeight(measurement);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Peso guardado'));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(Utils.snackBar('Algo ha fallado...', isBad: true));
      }
    }
  }
}
