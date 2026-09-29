import 'package:flutter/material.dart';
import 'package:gymcounter/hive/boxes.dart';
import 'package:gymcounter/models/_models.dart';
export 'package:provider/provider.dart';

class WeightProvider with ChangeNotifier {
  List<Measurement> weights = [];

  WeightProvider() {
    loadWeight();
  }

  //EXERCISES
  void loadWeight() {
    weights = Boxes.weights.keys.map((key) {
      final value = Boxes.weights.get(key);
      return Measurement.fromJson(value);
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
  }

  bool addWeight(Measurement value) {
    try {
      weights.add(value);
      Boxes.weights.put(value.id, value.toJson());
      notifyListeners();
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool removeWeight(Measurement value) {
    try {
      weights.add(value);
      Boxes.weights.delete(value.id);
      loadWeight();
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool updateWeight(Measurement value) {
    try {
      weights.removeWhere((w) => w.id == value.id);
      weights.add(value);
      Boxes.weights.delete(value.id);
      Boxes.weights.put(value.id, value.toJson());
      loadWeight();
      return true;
    } catch (ex) {
      return false;
    }
  }
}
