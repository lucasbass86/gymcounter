import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayRutinePage extends StatefulWidget {
  static const String routeName = 'PlayExercisePage';
  const PlayRutinePage({super.key});

  @override
  State<PlayRutinePage> createState() => _PlayRutinePageState();
}

class _PlayRutinePageState extends State<PlayRutinePage> {
  late Rutine rutine;
  late ExerciseSet currentExerciseSet;
  int currentSerie = 1;
  int totalSerie = 0;
  int reps = 0;
  int repsSerie = 0;
  int totalReps = 0;
  IconData icon = Utils.iconPlay;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _totalElapsed = Duration.zero;
  bool _running = false;
  bool _paused = false;
  int order = 1;
  ExerciseType type = ExerciseType.reps;
  Duration time = Duration.zero;
  int timeSerie = 0;
  bool isFinished = false;
  int lastOrder = 0;
  bool isNewSet = true;
  int firstReps = 0;
  int firstTime = 0;
  late Rutine finalRutine;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Preferences.activeScreen) {
      WakelockPlus.enable();
    }
  }

  @override
  void dispose() {
    if (Preferences.activeScreen) {
      WakelockPlus.disable();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rutine = ModalRoute.of(context)!.settings.arguments as Rutine;
    rutine.exercisesSet.sort((a, b) => a.order.compareTo(b.order));
    currentExerciseSet = rutine.exercisesSet.firstWhere((e) => e.order == order);
    type = currentExerciseSet.exercise.type;
    totalSerie = currentExerciseSet.sets.length;
    lastOrder = rutine.exercisesSet.last.order;
    repsSerie = currentExerciseSet.sets[currentSerie - 1].reps;
    time =
        currentExerciseSet.sets[currentSerie - 1].rest ??
        currentExerciseSet.sets[currentSerie - 1].time ??
        Duration.zero;
    timeSerie = time.inSeconds;
    if (isLoading) {
      finalRutine = rutine.copyWith(id: 'Test');
      isLoading = false;
    }
    if (isNewSet) {
      firstReps = repsSerie;
      firstTime = timeSerie;
      isNewSet = false;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _checkClose(context);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image(),
              _serieHeader(),
              20.h,
              _actions(),
              10.h,
              _buttonNext(),
              _bottomInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    final double size = 50;
    if (currentExerciseSet.sets[currentSerie - 1].rest != null) {
      return Expanded(child: Image.asset('assets/varios/descanso.png', height: 200, width: 200));
    }
    return Row(
      children: [
        const SizedBox(width: 20),
        Column(
          spacing: 10,
          children: [
            Image.asset(
              currentExerciseSet.exercise.muscleGroup.assetName,
              width: size,
              height: size,
            ),
            Image.asset(currentExerciseSet.exercise.equipment.assetName, width: size, height: size),
            Image.asset(
              currentExerciseSet.exercise.difficulty.assetName,
              width: size,
              height: size,
            ),
          ],
        ),
        Expanded(child: Image.asset(currentExerciseSet.exercise.image, height: 200, width: 200)),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => _checkClose(context), child: Text(rutine.name)),
      actions: [
        IconButton(
          tooltip: 'Información',
          onPressed: () async {
            _pause();
            await modalRutine(context, finalRutine, showPlay: false);
            _start();
          },
          icon: Icon(Utils.iconInfo),
        ),
        IconButton(
          tooltip: 'Reiniciar',
          onPressed: () async {
            final confirm = await showMessage(
              context: context,
              message: '¿Reiniciar?',
              cancel: true,
            );
            if (confirm != null && confirm) {
              _reset();
            }
          },
          icon: Icon(Utils.iconRestart),
        ),
      ],
    );
  }

  Widget _bottomInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Utils.iconTimer, color: AppColors.success),
                      Text(
                        _format(_totalElapsed),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  Text('Tiempo'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Utils.iconStatistics, color: AppColors.success),
                      Text('$totalReps', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                  Text('Total reps'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonNext() {
    if (!isFinished) {
      return BounceableWidget(
        scaleFactorOnTap: 1.1,
        onTap: _nextSet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Siguiente serie', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      );
    } else {
      return BounceableWidget(
        onTap: () => _finishWorkout(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Finalizar', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      );
    }
  }

  Widget _actions() {
    return Row(
      mainAxisAlignment: type == ExerciseType.reps
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        if (type == ExerciseType.reps)
          CircularButtonWidget(
            scaleFactorOnTap: 0.9,
            width: 60,
            height: 200,
            isCircle: false,
            iconData: Utils.iconRemove,
            onTap: () => setState(() {
              if (reps >= 1) {
                if (!_running) _start();
                reps--;
                totalReps--;
                currentExerciseSet.sets[currentSerie - 1].reps = reps;
              }
            }),
          ),
        CircularProgressWidget(
          currentValue: type == ExerciseType.reps ? reps : _elapsed.inSeconds,
          totalValue: type == ExerciseType.reps ? firstReps : firstTime,
          size: 200,
          strokeWidthInner: 10,
          strokeWidthOutter: 7,
          fontSize: type == ExerciseType.reps ? 70 : 40,
          showPercent: false,
          isTime: type == ExerciseType.time,
          progressColor: Utils.progressColor(
            type == ExerciseType.reps ? reps : _elapsed.inSeconds,
            type == ExerciseType.reps ? firstReps : firstTime,
          ),
          action: Row(
            children: [
              BounceableWidget(
                scaleFactorOnTap: 1.1,
                onTap: _running ? _pause : _start,
                child: Icon(
                  icon,
                  size: 50,
                  color: _running ? AppColors.warning : AppColors.success,
                ),
              ),
              BounceableWidget(
                onTap: _stop,
                child: Icon(Utils.iconStop, size: 50, color: AppColors.error),
              ),
            ],
          ),
        ),
        if (type == ExerciseType.reps)
          CircularButtonWidget(
            width: 60,
            height: 200,
            isCircle: false,
            iconData: Utils.iconAdd,
            onTap: () => setState(() {
              if (!_running) _start();
              reps++;
              totalReps++;
              currentExerciseSet.sets[currentSerie - 1].reps = reps;
            }),
          ),
      ],
    );
  }

  Widget _serieHeader() {
    if (currentExerciseSet.sets[currentSerie - 1].rest != null) {
      return Text(
        'Descanso',
        style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.w500),
      );
    }
    return Column(
      children: [
        Text(
          'Serie $currentSerie/$totalSerie',
          style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        10.h,
        SizedBox(
          height: 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: totalSerie,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 30,
                height: 10,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentSerie >= index + 1 ? AppColors.success : AppColors.card,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  void _start() {
    if (_running) return;
    icon = Utils.iconPause;
    _running = true;
    _paused = false;
    setState(() {
      _elapsed += const Duration(seconds: 1);
      _totalElapsed += const Duration(seconds: 1);
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
        _totalElapsed += const Duration(seconds: 1);
        if (currentExerciseSet.exercise.type == ExerciseType.time) {
          if (currentExerciseSet.sets[currentSerie - 1].isRest) {
            currentExerciseSet.sets[currentSerie - 1].rest = _elapsed;
          } else {
            currentExerciseSet.sets[currentSerie - 1].time = _elapsed;
          }
        }
        if (_elapsed.inSeconds == timeSerie) {
          _nextSet();
        }
      });
    });
  }

  void _pause() {
    _running = false;
    _paused = true;
    icon = Utils.iconPlay;
    setState(() {});
    _timer?.cancel();
  }

  void _stop({bool showConfirm = true, bool clearTotal = true}) async {
    bool resp = true;
    if (_running && showConfirm) {
      _pause();
      resp = await showSlideToUnlock(
        context,
        backColor: AppColors.primary,
        slideColor: AppColors.card,
      );
    }
    if (resp) {
      icon = Utils.iconPlay;
      _running = false;
      _paused = false;
      _timer?.cancel();
      setState(() {
        _elapsed = Duration.zero;
        if (clearTotal) {
          _totalElapsed = Duration.zero;
        }
      });
    } else {
      _start();
    }
  }

  void _checkClose(BuildContext context) async {
    if (_running || _paused) {
      _pause();
      final resp = await showMessage(
        context: context,
        message: '¿Cancelar el workout?',
        cancel: true,
      );
      if (resp != null && resp && context.mounted) {
        _stop(showConfirm: false);
        Navigator.pop(context);
      } else {
        _start();
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _nextSet() {
    if (currentSerie < totalSerie) {
      currentSerie++;
      reps = 0;
      _elapsed = Duration.zero;
      if (order == lastOrder && currentSerie == totalSerie) {
        isFinished = true;
      }
      isNewSet = true;
    } else {
      if (rutine.exercisesSet.any((e) => e.order == currentExerciseSet.order + 1)) {
        currentExerciseSet = rutine.exercisesSet.firstWhere(
          (e) => e.order == currentExerciseSet.order + 1,
        );
        order++;
        currentSerie = 1;
        reps = 0;
        isNewSet = true;
      } else {
        isFinished = true;
        _stop(showConfirm: false);
        _finishWorkout(context);
      }
    }
    setState(() {});
  }

  void _finishWorkout(BuildContext context) async {
    _pause();
    final confirm = await showMessage(
      context: context,
      message: '¿Finalizar entrenamiento?',
      cancel: true,
    );
    if (confirm != null && confirm && context.mounted) {
      _stop(showConfirm: false, clearTotal: false);
      GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
      gymProvider.addWorkout(Workout.fromRutine(rutine, _totalElapsed));
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Entrenamiento acabado'));
      Navigator.pop(context);
    } else {
      _start();
    }
  }

  void _reset() {
    _stop(showConfirm: false);
    currentSerie = 1;
    reps = 0;
    totalReps = 0;
    _totalElapsed = Duration.zero;
    order = 1;
    isFinished = false;
    setState(() {});
  }
}
