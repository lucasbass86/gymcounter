import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class WorkoutPage extends StatefulWidget {
  static const String routeName = 'WorkoutPage';
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late GymProvider gymProvider;
  TextEditingController controllerName = TextEditingController();
  Difficulty difficulty = Difficulty.intermediate;
  Workout? workout;
  Rutine? rutine;
  List<ExerciseSet> exerciseSets = [];
  DateTime date = DateTime.now();
  Duration time = Duration.zero;
  bool isWorkout = false;
  String titleAppBar = 'Nueva rutina';
  bool enabled = true;
  bool editing = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100)).then((_) => launchExercise());
  }

  void launchExercise() async {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is Exercise) {
      isWorkout = true;
      final Exercise exercise = arguments;
      await _addExercise(exercise);
      workout = Workout(
        name: '',
        date: date,
        time: time,
        exercisesSet: exerciseSets,
        difficulty: Difficulty.intermediate,
      );
      titleAppBar = 'Nuevo workout';
    }
    if (arguments is bool) {
      isWorkout = arguments;
      workout = Workout(
        name: '',
        date: date,
        time: time,
        exercisesSet: exerciseSets,
        difficulty: Difficulty.intermediate,
      );
      gymProvider.currentWorkout = workout;
      titleAppBar = 'Nuevo Workout';
      setState(() {});
    }
    if (arguments is Workout) {
      isWorkout = true;
      workout = arguments;
      // workout = gymProvider.workouts.firstWhere((w) => w.id == arguments.id);
      date = workout!.date;
      exerciseSets = workout!.exercisesSet;
      exerciseSets.sort((a, b) => a.order.compareTo(b.order));
      titleAppBar = workout!.name == '' ? 'Workout' : workout!.name;
      controllerName.text = workout!.name;
      time = workout!.time;
      difficulty = workout!.difficulty;
      setState(() {});
    }
    if (arguments is Rutine) {
      rutine = arguments;
      // rutine = gymProvider.rutines.firstWhere((r) => r.id == arguments.id);
      exerciseSets = rutine!.exercisesSet;
      exerciseSets.sort((a, b) => a.order.compareTo(b.order));
      difficulty = rutine!.difficulty;
      titleAppBar = rutine!.name == '' ? 'Rutina' : rutine!.name;
      controllerName.text = rutine!.name;
      time = rutine!.time;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context, listen: false);
    enabled = editing || (workout != null && workout!.finished ? false : true);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _checkClose(context);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _name(),
                      20.h,
                      _dateHour(),
                      20.h,
                      _difficult(),
                      20.h,
                      _exercises(context),
                    ],
                  ),
                ),
              ),
              _button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() {
    if (workout != null && workout!.finished) return SizedBox.shrink();
    return ButtonSaveWidget(
      onTap: () => workout == null ? _save() : _finish(),
      title: isWorkout ? 'Finalizar workout' : 'Guardar rutina',
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(
        onTap: () => _checkClose(context),
        child: Text(controllerName.text == '' ? titleAppBar : controllerName.text),
      ),
      actions: [
        if (workout == null || !workout!.finished)
          IconButton(
            onPressed: workout != null ? _finish : _save,
            icon: Row(
              spacing: 5,
              children: [
                Icon(Utils.iconCheck, color: AppColors.success),
                Text(
                  isWorkout ? 'Finalizar' : 'Guardar',
                  style: TextStyle(color: AppColors.success),
                ),
              ],
            ),
          ),
        if (workout == null || !workout!.finished)
          IconButton(
            onPressed: () async {
              final confirm = await showSlideToUnlock(
                context,
                backColor: AppColors.primary,
                slideColor: AppColors.card,
              );
              if (confirm && context.mounted) {
                gymProvider.currentWorkout = null;
                Navigator.pop(context);
              }
            }, //workout != null ? _finish : _save,
            icon: Icon(Utils.iconDelete, color: AppColors.success),
          ),
        if (workout != null &&
            workout!.finished &&
            !gymProvider.rutines.any((r) => r.idWorkout == workout!.id) &&
            workout!.idRutine == '')
          IconButton(
            tooltip: 'Guardar como rutina',
            onPressed: () async {
              final resp = await showMessage(
                context: context,
                message: '¿Guardar como rutina?',
                cancel: true,
              );
              if (resp != null && resp && context.mounted) {
                gymProvider.addRutine(Rutine.fromWorkout(workout!));
                ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Rutina creada'));
                setState(() {});
              }
            },
            icon: Icon(Utils.iconReps),
          ),
        if (workout != null && workout!.finished)
          IconButton(
            tooltip: 'Borrar',
            onPressed: () async {
              final resp = await showMessage(
                context: context,
                message: '¿Borrar el workout?',
                cancel: true,
              );
              if (resp != null && resp && context.mounted) {
                gymProvider.deleteWorkout(workout!);
                ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Workout borrado . . .'));
                Navigator.pop(context);
              }
            },
            icon: Icon(Utils.iconDelete),
          ),
        if (workout != null && workout!.finished && !editing)
          IconButton(
            tooltip: 'Editar',
            onPressed: () {
              editing = true;
              setState(() {});
            },
            icon: Icon(Utils.iconEdit),
          ),
        if (editing)
          IconButton(
            tooltip: 'Guardar',
            onPressed: () {
              editing = false;
              _finish();
              setState(() {});
            },
            icon: Icon(Utils.iconSave),
          ),
      ],
    );
  }

  void _checkClose(BuildContext context) async {
    if (workout != null && workout!.finished) {
      Navigator.of(context).pop();
    } else if (exerciseSets.isNotEmpty || controllerName.text.isNotEmpty) {
      final resp = await showMessage(
        context: context,
        message: isWorkout ? '¿Finalizar workout?' : '¿Guardar rutina?',
        cancel: true,
        acceptText: 'Sí',
        cancelText: 'No',
      );
      if (resp != null && resp is bool && resp) {
        if (workout == null) {
          _save();
        } else {
          _finish();
        }
      } else if (resp != null && resp is bool && !resp) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      gymProvider.currentWorkout = null;
      Navigator.of(context).pop();
    }
  }

  Widget _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          isWorkout ? 'NOMBRE WORKOUT' : 'NOMBRE DE LA RUTINA',
          style: TextStyle(color: AppColors.success),
        ),
        TextFormField(
          controller: controllerName,
          maxLength: 50,
          enabled: enabled,
          decoration: InputDecoration(hintText: 'Ej: Low body', counterText: ''),
          onChanged: (value) {
            if (workout != null) {
              workout!.name = value;
              gymProvider.currentWorkout = workout;
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _dateHour() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: enabled
                ? () async {
                    final resp = await showDate(context, initialDate: date);
                    if (resp != null) {
                      date = resp;
                      if (workout != null) {
                        workout!.date = date;
                        gymProvider.currentWorkout = workout;
                      }
                      setState(() => ());
                    }
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(Utils.iconCalendar),
                  Text(Utils.dateEnglishToSpanish(date), style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: enabled
                ? () async {
                    final resp = await showPacePicker(
                      context: context,
                      initialPace: time,
                      hasHours: true,
                    );
                    if (resp != null) {
                      time = resp;
                      if (workout != null) {
                        workout!.time = time;
                        gymProvider.currentWorkout = workout;
                      }
                      setState(() => ());
                    }
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  CountUpDuration(
                    duration: time,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Utils.iconTimer),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _difficult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('DIFICULTAD', style: TextStyle(color: AppColors.success)),
        IgnorePointer(
          ignoring: !enabled,
          child: Row(
            spacing: 10,
            children: [
              DifficultWidget(
                selDiff: difficulty,
                diff: Difficulty.beginner,
                onTap: (value) => _updateDifficulty(value),
              ),
              DifficultWidget(
                selDiff: difficulty,
                diff: Difficulty.intermediate,
                onTap: (value) => _updateDifficulty(value),
              ),
              DifficultWidget(
                selDiff: difficulty,
                diff: Difficulty.advanced,
                onTap: (value) => _updateDifficulty(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _exercises(BuildContext context) {
    exerciseSets.sort((a, b) => a.order.compareTo(b.order));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LISTA DE EJERCICIOS', style: TextStyle(color: AppColors.success)),
            if (enabled)
              GestureDetector(
                onTap: () async {
                  MuscleGroup? muscleGroup = await modalMuscularGroup(context);
                  if (muscleGroup != null && context.mounted) {
                    Exercise? exercise = await modalExercise(context, muscleGroup);
                    if (exercise != null && context.mounted) {
                      _addExercise(exercise);
                    }
                  }
                },
                child: Icon(Utils.iconAdd, size: 30),
              ),
          ],
        ),
        ...exerciseSets.map((e) {
          return ExerciseSetWidget(
            exerciseSet: e,
            onDelete: () => setState(() {
              exerciseSets.remove(e);
              workout!.exercisesSet = exerciseSets;
              gymProvider.currentWorkout = workout;
              time = workout!.totalTime;
            }),
            onUpdate: (time) {
              _updateExerciseSets();
              if (workout != null) this.time = Utils.acumularDurations([workout!.time, time]);
            },
            // lock: workout?.finished ?? false,
            lock: !enabled,
            rutine: rutine,
            workout: workout,
            onUp: () {
              if (e.order > 1) swapOrder(e.order, e.order - 1);
            },
            onDown: () {
              if (e.order < exerciseSets.length) swapOrder(e.order, e.order + 1);
            },
          );
        }),
      ],
    );
  }

  void _updateExerciseSets() {
    if (workout != null) {
      workout!.exercisesSet = exerciseSets;
      gymProvider.currentWorkout = workout;
    }
    if (rutine != null) rutine!.exercisesSet = exerciseSets;
    setState(() {});
  }

  void swapOrder(int a, int b) {
    final exA = exerciseSets.firstWhere((ex) => ex.order == a);
    final exB = exerciseSets.firstWhere((ex) => ex.order == b);

    exA.order = b;
    exB.order = a;
    _updateExerciseSets();
  }

  Future<void> _addExercise(Exercise exercise) async {
    if (exercise.type == ExerciseType.reps) {
      int? series = await modalNumberOfSeries(context);
      if (series != null) {
        ExerciseSet set = ExerciseSet(
          exercise: exercise,
          order: exerciseSets.length + 1,
          sets: [...List.generate(series, (index) => SetResult())],
        );
        exerciseSets.add(set);
        if (workout != null) {
          workout!.exercisesSet = exerciseSets;
          gymProvider.currentWorkout = workout;
        }
        setState(() {});
      }
    } else {
      final Duration? resp = await showPacePicker(
        context: context,
        title: 'Indica el tiempo (HH:MM:SS)',
        hasHours: true,
      );
      if (resp != null) {
        time = resp;
        ExerciseSet set = ExerciseSet(
          exercise: exercise,
          order: exerciseSets.length + 1,
          sets: [SetResult(time: time)],
        );
        exerciseSets.add(set);
        if (workout != null) {
          workout!.exercisesSet = exerciseSets;
          time = Utils.acumularDurations([workout!.time, time]);
          workout!.time = time;
          gymProvider.currentWorkout = workout;
        }
        setState(() {});
      }
    }
  }

  void _save() {
    if (controllerName.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Indica el nombre de la rutina', isBad: true));
      return;
    }
    rutine ??= Rutine(
      name: controllerName.text,
      date: date,
      exercisesSet: exerciseSets,
      difficulty: difficulty,
      time: time,
    );
    rutine!.name = controllerName.text;
    rutine!.date = date;
    rutine!.exercisesSet = exerciseSets;
    rutine!.difficulty = difficulty;
    rutine!.time = time;
    if (gymProvider.addRutine(rutine!)) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Rutina guardada'));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Algo ha fallado...'));
    }
  }

  void _finish() {
    if (controllerName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Indica el nombre', isBad: true));
      return;
    }
    if (exerciseSets.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Indica algún ejercicio', isBad: true));
      return;
    }
    workout!.finished = true;
    workout!.time = time;
    gymProvider.currentWorkout = workout;
    final ok = gymProvider.addWorkout(gymProvider.currentWorkout!);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Workout finalizado'));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Algo ha fallado . . .', isBad: true));
    }
    Navigator.pop(context);
  }

  void _updateDifficulty(Difficulty value) {
    setState(() {
      difficulty = value;
      if (workout != null) {
        workout!.difficulty = value;
        gymProvider.currentWorkout = workout;
      }
    });
  }
}
