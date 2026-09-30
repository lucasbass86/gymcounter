// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/hive/boxes.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/secrets/secrets.dart';
import 'package:http/http.dart' as http;

class User {
  String email;
  String password;
  List<Exercise> exercises;
  List<Measurement> measurements;
  List<Rutine> rutines;
  List<Workout> workouts;
  List<Target> targets;

  @override
  String toString() => email;

  User({
    required this.email,
    required this.password,
    required this.exercises,
    required this.measurements,
    required this.rutines,
    required this.workouts,
    required this.targets,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'],
    password: json['password'].toString(),
    exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    measurements:
        (json['measurements'] as List?)?.map((e) => Measurement.fromJson(e)).toList() ?? [],
    rutines: (json['rutines'] as List?)?.map((e) => Rutine.fromJson(e)).toList() ?? [],
    workouts: (json['workouts'] as List?)?.map((e) => Workout.fromJson(e)).toList() ?? [],
    targets: (json['targets'] as List?)?.map((e) => Target.fromJson(e)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'exercises': (exercises).map((e) => e.toJson()).toList(),
    'measurements': (measurements).map((e) => e.toJson()).toList(),
    'rutines': (rutines).map((e) => e.toJson()).toList(),
    'workouts': (workouts).map((e) => e.toJson()).toList(),
    'targets': (targets).map((e) => e.toJson()).toList(),
  };
}

class BackupService {
  static final _baseUrl = Secret.firebaseUrl;

  static Future<void> addBackUp(User user) async {
    final String emailKey = user.email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.put(url, body: jsonEncode(user.toJson()));
    final decodedData = resp.body;
  }

  static Future<User?> getBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.get(url);
    if (resp.statusCode != 200 || resp.body == 'null') {
      print('No se encontró el backup');
      return null;
    }
    final Map<String, dynamic> data = jsonDecode(resp.body);
    User user = User.fromJson(data);
    return user;
  }

  static Future<void> deleteBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.delete(url);
    print(resp);
  }

  static Future<void> checkBackUp(BuildContext context) async {
    final navigator = Navigator.of(context);
    if (Preferences.backUp.isNotEmpty && Boxes.exercises.values.isNotEmpty) {
      if (DateTime.now().difference(DateTime.parse(Preferences.backUp)).inDays >=
          Preferences.backupDays) {
        final resp = await showMessage(
          context: context,
          message: 'Llevas ciertos días sin hacer copia de seguridad. ¿Hacer copia?',
          cancel: true,
        );
        if (resp) {
          navigator.pushNamed(SettingsPage.routeName);
        }
      }
    }
  }
}
