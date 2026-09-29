import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ExerciseHistoryPage extends StatefulWidget {
  static const String routeName = 'ExerciseHistoryPage';
  const ExerciseHistoryPage({super.key});

  @override
  State<ExerciseHistoryPage> createState() => _ExerciseHistoryPageState();
}

class _ExerciseHistoryPageState extends State<ExerciseHistoryPage> {
  late Exercise exercise;
  HistoryMode mode = Utils.getHistoryModeByIndex(Preferences.indexTabExerciseHistory);
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    exercise = ModalRoute.of(context)!.settings.arguments as Exercise;
    GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
    List<Workout> workouts = gymProvider.getWorkoutsByHistory(mode, date, exercise);
    workouts.sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      appBar: _appBar(context, workouts.length),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HistoryModesWidget(
                mode: mode,
                withDay: false,
                onTap: (value) {
                  Preferences.indexTabExerciseHistory = Utils.getIndexByHistoryMode(value);
                  setState(() => mode = value);
                },
              ),
              20.h,
              HistoryFilterWidget(
                mode: mode,
                date: date,
                onChange: (value) => setState(() => date = value),
              ),
              20.h,
              ExerciseHistoryWidget(workouts: workouts, exercise: exercise),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, int numOfExercises) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(exercise.name)),
      actions: [
        Text(
          numOfExercises == 1 ? '1 ejercicio' : '$numOfExercises ejercicios',
          style: TextStyle(color: AppColors.success),
        ),
      ],
    );
  }
}
