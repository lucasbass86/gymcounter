import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ExercisesListPage extends StatefulWidget {
  static const String routeName = 'ExercisesListPage';
  const ExercisesListPage({super.key});

  @override
  State<ExercisesListPage> createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
  late GymProvider gymProvider;
  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context);
    List<MuscleGroup> musclesGroup =
        gymProvider.exercises.map((e) => e.muscleGroup).toSet().toList()
          ..sort((a, b) => a.displayName.compareTo(b.displayName));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Ejercicios')),
        actions: [
          IconButton(
            tooltip: 'Ejemplos',
            onPressed: () => modalExamplesExercises(context),
            icon: Icon(Utils.iconList),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: musclesGroup.isEmpty
                  ? Icon(Utils.iconDumbbell, color: AppColors.divider, size: 150)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [...musclesGroup.map((value) => _exercises(value))],
                      ),
                    ),
            ),
            ButtonSaveWidget(
              onTap: () => Navigator.pushNamed(context, NewExercisePage.routeName),
              title: 'Nuevo ejercicio',
              icon: Utils.iconAdd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exercises(MuscleGroup value) {
    List<Exercise> exercises = gymProvider.exercises.where((e) => e.muscleGroup == value).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Image.asset(value.assetName, width: 50, height: 50),
                  Text(value.displayName, style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
              10.h,
              ExercisesListWidget(
                exercises: exercises,
                onSelect: (exercise) =>
                    Navigator.pushNamed(context, ExercisePage.routeName, arguments: exercise.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
