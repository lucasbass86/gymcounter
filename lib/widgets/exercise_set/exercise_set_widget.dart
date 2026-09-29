import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ExerciseSetWidget extends StatefulWidget {
  final ExerciseSet exerciseSet;
  final VoidCallback onDelete;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final Function(Duration) onUpdate;
  final bool lock;
  final Workout? workout;
  final Rutine? rutine;
  const ExerciseSetWidget({
    super.key,
    required this.exerciseSet,
    required this.onDelete,
    required this.onUpdate,
    required this.lock,
    required this.onUp,
    required this.onDown,
    this.workout,
    this.rutine,
  });

  @override
  State<ExerciseSetWidget> createState() => _ExerciseSetWidgetState();
}

class _ExerciseSetWidgetState extends State<ExerciseSetWidget> {
  late List<TextEditingController> repsControllers;
  late List<TextEditingController> weightControllers;
  late List<TextEditingController> restControllers;
  late List<FocusNode> repsFocus;
  late List<FocusNode> weightFocus;
  late List<FocusNode> restFocus;

  int get totalReps => widget.exerciseSet.sets.fold(0, (pre, el) => pre + el.reps);

  Duration get totalTime => widget.exerciseSet.sets.fold(
    Duration.zero,
    (p1, set) => p1 + (set.time != null ? set.time! : Duration.zero),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(covariant ExerciseSetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseSet.sets.length != widget.exerciseSet.sets.length) {
      loadData();
    }
  }

  void loadData() {
    repsControllers = [];
    weightControllers = [];
    restControllers = [];
    repsFocus = [];
    weightFocus = [];
    restFocus = [];

    for (final set in widget.exerciseSet.sets) {
      repsControllers.add(TextEditingController(text: set.reps == 0 ? '' : set.reps.toString()));
      weightControllers.add(
        TextEditingController(text: set.weight == 0 ? '' : set.weight.toStringAsFixed(2)),
      );
      restControllers.add(
        TextEditingController(
          text: set.rest == null
              ? Preferences.restMinutes != 0 || Preferences.restSeconds != 0
                    ? Utils.durationToString(
                        Duration(
                          minutes: Preferences.restMinutes,
                          seconds: Preferences.restSeconds,
                        ),
                      )
                    : ''
              : Utils.durationToString(set.rest!),
        ),
      );

      repsFocus.add(FocusNode());
      weightFocus.add(FocusNode());
      restFocus.add(FocusNode());
    }
  }

  void addSet({SetResult? set}) {
    setState(() {
      widget.exerciseSet.sets.add(set ?? SetResult());
      repsControllers.add(TextEditingController());
      weightControllers.add(TextEditingController());
      restControllers.add(TextEditingController());
      repsFocus.add(FocusNode());
      weightFocus.add(FocusNode());
      restFocus.add(FocusNode());
    });
  }

  void removeSet(int index) {
    setState(() {
      widget.exerciseSet.sets.removeAt(index);
      repsControllers.removeAt(index);
      weightControllers.removeAt(index);
      restControllers.removeAt(index);
      repsFocus.removeAt(index);
      weightFocus.removeAt(index);
      restFocus.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(widget.exerciseSet.id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_header(context), 20.h, _sets(context), 10.h, _footer()],
        ),
      ),
    );
  }

  Widget _sets(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.exerciseSet.sets.length,
      itemBuilder: (_, index) {
        final set = widget.exerciseSet.sets[index];
        final repsCtrl = repsControllers[index];
        final weightCtrl = weightControllers[index];
        final restCtrl = restControllers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              if (set.isRest)
                Row(
                  spacing: 10,
                  children: [
                    SizedBox(width: 60, child: Center(child: Text('Rec'))),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: !widget.lock
                          ? () async {
                              await picker(context, set, restCtrl);
                              widget.onUpdate.call(totalTime);
                            }
                          : null,
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            Utils.durationToString(set.rest ?? Duration()),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!set.isRest && widget.exerciseSet.exercise.type == ExerciseType.time)
                GestureDetector(
                  onTap: !widget.lock
                      ? () async {
                          await timePicker(context, set);
                          widget.onUpdate.call(totalTime);
                        }
                      : null,
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        Utils.durationToString(set.time ?? Duration(), showZeroHour: true),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              if (!set.isRest && widget.exerciseSet.exercise.type == ExerciseType.reps)
                Row(
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 40,
                      child: TextField(
                        enabled: !widget.lock,
                        controller: repsCtrl,
                        focusNode: repsFocus[index],
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 15),
                        decoration: const InputDecoration(hintText: '0', counterText: ''),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(weightFocus[index]);
                        },
                        onChanged: (value) {
                          final reps = int.tryParse(value) ?? 0;
                          set.reps = reps;
                          widget.onUpdate.call(totalTime);
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: TextField(
                        enabled: !widget.lock,
                        controller: weightCtrl,
                        focusNode: weightFocus[index],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 15),
                        decoration: const InputDecoration(hintText: '0 Kg', counterText: ''),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          if (index + 1 < repsFocus.length) {
                            FocusScope.of(context).requestFocus(repsFocus[index + 1]);
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        onChanged: (value) {
                          final w = double.tryParse(value) ?? 0;
                          set.weight = w;
                          widget.onUpdate.call(totalTime);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              Expanded(child: Container()),
              if (!widget.lock)
                GestureDetector(
                  onTap: () async => _setMenu(context, set, restCtrl, index),
                  child: Icon(Utils.iconMenu),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _setMenu(
    BuildContext context,
    SetResult set,
    TextEditingController restCtrl,
    int index,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (!set.isRest) {
                    picker(context, set, restCtrl, close: true);
                  } else {
                    set.time = set.rest;
                    set.rest = Duration.zero;
                    set.isRest = false;
                    Navigator.pop(context);
                  }
                  widget.onUpdate.call(totalTime);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Establecer como  ${set.isRest ? 'tiempo' : 'recuperación'}'),
                    Icon(Utils.iconTimer),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  {
                    SetResult copy = SetResult(reps: set.reps, weight: set.weight, rest: set.rest);
                    addSet(set: copy);
                    widget.onUpdate.call(totalTime);
                    Navigator.pop(context);
                    loadData();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Copiar'), Icon(Utils.iconCopy)],
                ),
              ),
              Divider(color: AppColors.divider),
              GestureDetector(
                onTap: () {
                  removeSet(index);
                  widget.onUpdate.call(totalTime);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Eliminar'),
                    Icon(Utils.iconDelete, color: AppColors.error),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.exerciseSet.exercise.type == ExerciseType.reps) Text('Reps: $totalReps'),
        if (widget.exerciseSet.exercise.type == ExerciseType.time)
          Text('Total: ${Utils.durationToString(totalTime, showZeroHour: true)}'),
        if (!widget.lock)
          BounceableWidget(
            scaleFactorOnTap: 1.1,
            onTap: addSet,
            child: const Text('+ Añadir serie'),
          ),
        if (widget.lock)
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              ExercisePage.routeName,
              arguments: widget.exerciseSet.exercise.id,
            ),
            child: Icon(Utils.iconForward),
          ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => showImage(context, widget.exerciseSet.exercise.image),
          child: Row(
            spacing: 10,
            children: [
              Image.asset(widget.exerciseSet.exercise.image, width: 30, height: 30),
              Text(
                widget.exerciseSet.exercise.name,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
        if (!widget.lock)
          GestureDetector(
            onTap: () async => await _headerMenu(context),
            child: Icon(Utils.iconMenu, color: AppColors.warning),
          ),
        if (widget.lock)
          GestureDetector(
            onTap: () => showImage(context, widget.exerciseSet.exercise.muscleGroup.assetName),
            child: Image.asset(
              widget.exerciseSet.exercise.muscleGroup.assetName,
              width: 30,
              height: 30,
            ),
          ),
      ],
    );
  }

  Future<dynamic> _headerMenu(BuildContext context) {
    int maxOrder = widget.rutine != null
        ? widget.rutine!.exercisesSet.length
        : widget.workout!.exercisesSet.length;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  MuscleGroup? muscleGroup = await modalMuscularGroup(context);
                  if (muscleGroup != null && context.mounted) {
                    Exercise? exercise = await modalExercise(context, muscleGroup);
                    if (exercise != null) {
                      widget.exerciseSet.exercise = exercise;
                      setState(() {});
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Cambiar ejercicio'), Icon(Utils.iconReps)],
                ),
              ),
              Divider(color: AppColors.divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.exerciseSet.order > 1)
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onUp.call();
                        },
                        leading: Icon(Utils.iconUP),
                        title: Text('Subir'),
                      ),
                    ),
                  if (widget.exerciseSet.order < maxOrder)
                    Flexible(
                      flex: 1,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onDown.call();
                        },
                        trailing: Icon(Utils.iconDown),
                        title: Text('Bajar'),
                      ),
                    ),
                ],
              ),
              Divider(color: AppColors.divider),
              GestureDetector(
                onTap: () {
                  widget.onDelete.call();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Borrar registro'),
                    Icon(Utils.iconDelete, color: AppColors.error),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> picker(
    BuildContext context,
    SetResult set,
    TextEditingController controller, {
    bool close = false,
  }) async {
    final resp = await showPacePicker(
      context: context,
      title: 'Indica la recuperación (MM:SS)',
      initialPace: !set.isRest && set.time != null
          ? set.time!
          : set.rest ??
                ((Preferences.restMinutes != 0 || Preferences.restSeconds != 0)
                    ? Duration(minutes: Preferences.restMinutes, seconds: Preferences.restSeconds)
                    : Duration()),
    );
    if (resp != null && context.mounted) {
      set.isRest = true;
      set.rest = resp;
      set.time = Duration.zero;
      set.reps = 0;
      set.weight = 0;
      controller.text = Utils.durationToString(set.rest!);
      if (close) {
        Navigator.pop(context);
      }
      setState(() {});
    }
  }

  Future<void> timePicker(BuildContext context, SetResult set, {bool close = false}) async {
    final Duration? resp = await showPacePicker(
      context: context,
      initialPace: set.time ?? Duration.zero,
      hasHours: true,
      title: 'Indica el tiempo (HH:MM:SS)',
    );
    if (resp != null && context.mounted) {
      set.time = resp;
      set.reps = 0;
      set.weight = 0;
      if (close) {
        Navigator.pop(context);
      }
      setState(() {});
    }
  }
}
