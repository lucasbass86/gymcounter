import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'package:gymcounter/helpers/utils.dart';

class SetResult {
  final String id;
  int reps;
  double weight;
  Duration? rest;
  Duration? time;
  bool isRest;

  @override
  String toString() =>
      'Reps:$reps-We:$weight${time != null ? 'Tm:${Utils.durationToString(time!)}' : Duration.zero}';

  SetResult({this.reps = 0, this.weight = 0, this.rest, this.isRest = false, this.time})
    : id = Uuid().v4();

  SetResult.withId({
    required this.id,
    this.reps = 0,
    this.weight = 0,
    this.rest,
    this.isRest = false,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'rest': rest?.inSeconds,
      'time': time?.inSeconds,
      'isRest': isRest,
    };
  }

  factory SetResult.fromMap(Map<String, dynamic> map) {
    return SetResult.withId(
      id: map['id'] ?? '',
      reps: map['reps']?.toInt() ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      rest: map['rest'] != null ? Duration(seconds: map['rest']) : null,
      time: map['time'] != null
          ? (map['time'] is String)
                ? Utils.timeOfDayFromJsonToDuration(map['time'])
                : Duration(seconds: map['time'])
          : null,
      isRest: map['isRest'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SetResult.fromJson(String source) => SetResult.fromMap(json.decode(source));

  SetResult copyWith({
    String? id,
    int? reps,
    double? weight,
    ValueGetter<Duration?>? rest,
    ValueGetter<Duration?>? time,
    bool? isRest,
  }) {
    return SetResult.withId(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      rest: rest != null ? rest() : this.rest,
      time: time != null ? time() : this.time,
      isRest: isRest ?? this.isRest,
    );
  }
}
