import 'package:flutter/material.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/services/license_service.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  MainPage.routeName: (_) => const MainPage(),
  HistoryPage.routeName: (_) => const HistoryPage(),
  StatisticsPage.routeName: (_) => const StatisticsPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
  NewExercisePage.routeName: (_) => const NewExercisePage(),
  PlayRutinePage.routeName: (_) => const PlayRutinePage(),
  WorkoutPage.routeName: (_) => const WorkoutPage(),
  RutinesListPage.routeName: (_) => const RutinesListPage(),
  ExercisesListPage.routeName: (_) => const ExercisesListPage(),
  WeightPage.routeName: (_) => const WeightPage(),
  ExercisePage.routeName: (_) => const ExercisePage(),
  ExerciseHistoryPage.routeName: (_) => const ExerciseHistoryPage(),
  WorkoutsListPage.routeName: (_) => const WorkoutsListPage(),
  StatisticsListPage.routeName: (_) => const StatisticsListPage(),
  RutineDetailPage.routeName: (_) => RutineDetailPage(),
  ListPage.routeName: (_) => ListPage(),
  UpdatePage.routeName: (_) => const UpdatePage(),
};
