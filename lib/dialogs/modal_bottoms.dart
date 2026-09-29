import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

Future<MuscleGroup?> modalMuscularGroup(BuildContext context) async {
  GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
  MuscleGroup? muscleGroup;
  List<MuscleGroup> values = gymProvider.exercises.map((e) => e.muscleGroup).toSet().toList();
  values.sort((a, b) => a.displayName.compareTo(b.displayName));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grupos musculares', style: TextStyle(color: Colors.white, fontSize: 20)),
                20.h,
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...values.map((value) {
                          return MusculargroupWidget(
                            onTap: () {
                              muscleGroup = value;
                              Navigator.pop(context, muscleGroup);
                            },
                            muscleGroup: value,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<Exercise?> modalExamplesExercises(BuildContext context) async {
  List<MuscleGroup> muscle = [...MuscleGroup.values];
  muscle.sort((a, b) => a.displayName.compareTo(b.displayName));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ejemplos de ejercicios',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  30.h,
                  ...muscle.map((group) {
                    List<Exercise> exercises = ExercisesExamples.fullList
                        .where((g) => g.muscleGroup == group)
                        .toList();
                    return Column(
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Image.asset(group.assetName, width: 50, height: 50),
                            Text(
                              group.displayName,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        10.h,
                        ExercisesListWidget(exercises: exercises, margin: 40, onSelect: null),
                        20.h,
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<Exercise?> modalExercise(BuildContext context, MuscleGroup muscleGroup) async {
  GymProvider gymProvider = Provider.of(context, listen: false);
  final List<Exercise> exercises = gymProvider.exercises
      .where((e) => e.muscleGroup == muscleGroup)
      .toList();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lista de ${muscleGroup.displayName}',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  20.h,
                  ExercisesListWidget(
                    exercises: exercises,
                    margin: 0,
                    onSelect: (value) => Navigator.pop(context, value),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<int?> modalNumberOfSeries(BuildContext context) {
  int series = 1;
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Número de series', style: TextStyle(color: Colors.white, fontSize: 20)),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularButtonWidget(
                      scaleFactorOnTap: 0.9,
                      width: 60,
                      height: 60,
                      iconData: Utils.iconRemove,
                      onTap: () => setState(() {
                        if (series > 1) {
                          series--;
                        }
                      }),
                    ),
                    Text('$series', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                    CircularButtonWidget(
                      width: 60,
                      height: 60,
                      iconData: Utils.iconAdd,
                      onTap: () => setState(() => series++),
                    ),
                  ],
                ),
                20.h,
                ButtonSaveWidget(
                  scaleFactor: 1.1,
                  onTap: () => Navigator.pop(context, series),
                  title: 'Aceptar',
                  icon: Utils.iconCheck,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> modalIMCInfo(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text('Información sobre el IMC.', style: TextStyle(fontSize: 25, color: Colors.white)),
            10.h,
            Row(
              children: [
                Text('Peso bajo: ', style: TextStyle(color: Colors.blue)),
                Text('Menos de 18,5 kg/m²'),
              ],
            ),
            Row(
              children: [
                Text('Peso normal: ', style: TextStyle(color: Colors.green)),
                Text('Entre 18,5 y 24,9 kg/m²'),
              ],
            ),
            Row(
              children: [
                Text('Sobrepeso: ', style: TextStyle(color: Colors.orange)),
                Text('entre 25 y 29,9 kg/m²'),
              ],
            ),
            Row(
              children: [
                Text('Obesidad: ', style: TextStyle(color: Colors.red)),
                Text('30 kg/m² o más'),
              ],
            ),
            30.h,
            Text(
              '*Es importante notar que el IMC es una estimación general y no distingue entre masa muscular y grasa corporal.',
            ),
          ],
        ),
      );
    },
  );
}

Future<void> modalRutine(BuildContext context, Rutine rutine, {bool showPlay = true}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text('Ejercicios de la rutina', style: TextStyle(color: Colors.white, fontSize: 23)),
              20.h,
              ListView.separated(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: rutine.exercisesSet.length,
                itemBuilder: (BuildContext context, int index) {
                  final ExerciseSet ex = rutine.exercisesSet[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Image.asset(ex.exercise.image, width: 30, height: 30),
                              Text(
                                ex.exercise.name,
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ],
                          ),
                          Image.asset(ex.exercise.equipment.assetName, width: 30, height: 30),
                        ],
                      ),
                      10.h,
                      ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ex.sets.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: AppColors.divider),
                        itemBuilder: (BuildContext context, int index) {
                          final SetResult set = ex.sets[index];
                          return Container(
                            margin: const EdgeInsets.only(left: 40),
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.subtitle),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                if (ex.exercise.type == ExerciseType.reps)
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Text('${set.reps} reps'),
                                      if (set.weight != 0) Text('${set.weight} kgs'),
                                    ],
                                  ),
                                if (set.rest != null)
                                  Row(
                                    spacing: 10,
                                    children: [Text('Rec: ${Utils.durationToString(set.rest!)}')],
                                  ),
                                if (set.rest == null &&
                                    ex.exercise.type == ExerciseType.time &&
                                    set.time != null)
                                  Text(Utils.durationToString(set.time!)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Column(
                  children: [
                    Divider(color: AppColors.divider),
                    20.h,
                  ],
                ),
              ),
              40.h,
              if (showPlay)
                ButtonSaveWidget(
                  onTap: () async {
                    await Navigator.pushNamed(context, PlayRutinePage.routeName, arguments: rutine);
                    if (context.mounted) Navigator.pop(context);
                  },
                  title: 'Iniciar',
                  icon: Utils.iconPlay,
                  backColor: AppColors.success,
                ),
            ],
          ),
        ),
      );
    },
  );
}

Future<Rutine?> modalPlayRutine(BuildContext context) {
  GymProvider gymProvider = Provider.of(context, listen: false);
  List<Rutine> rutines = gymProvider.rutines;
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rutinas disponibles',
              style: TextStyle(fontSize: 23, color: AppColors.primaryDark),
            ),
            20.h,
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: rutines.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.asset(rutines[index].difficulty.assetName, width: 30, height: 30),
                  title: Text(
                    rutines[index].name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    rutines[index].exercisesSet.length == 1
                        ? '1 ejercicio'
                        : '${rutines[index].exercisesSet.length} ejercicios',
                    style: TextStyle(color: AppColors.subtitle),
                  ),
                  onTap: () => Navigator.pop(context, rutines[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: AppColors.divider),
            ),
          ],
        ),
      );
    },
  );
}
