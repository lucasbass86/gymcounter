import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:uuid/uuid.dart';

class NewExercisePage extends StatefulWidget {
  static const String routeName = 'NewExercisePage';
  const NewExercisePage({super.key});

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  late GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
  Exercise? exercise;
  Exercise? example;
  ExerciseType exerciseType = ExerciseType.reps;
  Difficulty difficulty = Difficulty.intermediate;
  MuscleGroup? muscleGroup;
  Equipment equipment = Equipment.none;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 400)).then((_) {
      _loadData();
    });
  }

  void _loadData() {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is Exercise) {
      setState(() {
        exercise = arguments;
        controllerName = TextEditingController(text: exercise!.name);
        controllerNote = TextEditingController(text: exercise!.note);
        exerciseType = exercise!.type;
        difficulty = exercise!.difficulty;
        muscleGroup = exercise!.muscleGroup;
        equipment = exercise!.equipment;
        example = ExercisesExamples.fullList.firstWhere((e) => e.image == exercise!.image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _checkClose(context);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: GestureDetector(
            onTap: () => _checkClose(context),
            child: Text(controllerName.text == '' ? 'Nuevo ejercicio' : controllerName.text),
          ),
          actions: [
            GestureDetector(
              onTap: _save,
              child: Row(
                spacing: 5,
                children: [
                  Icon(Utils.iconCheck, color: AppColors.success),
                  Text('Guardar', style: TextStyle(color: AppColors.success)),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _name(),
                      20.h,
                      _group(),
                      20.h,
                      _variants(),
                      20.h,
                      _type(),
                      20.h,
                      _equip(),
                      20.h,
                      _difficult(),
                      20.h,
                      _note(),
                      20.h,
                      _delete(context),
                      20.h,
                    ],
                  ),
                ),
              ),
              ButtonSaveWidget(onTap: () => _save(), title: 'Guardar ejercicio'),
            ],
          ),
        ),
      ),
    );
  }

  void _checkClose(BuildContext context) async {
    if (muscleGroup != null || controllerName.text.isNotEmpty) {
      final resp = await showMessage(
        context: context,
        message: '¿Guardar el ejercicio?',
        cancel: true,
        acceptText: 'Sí',
        cancelText: 'No',
      );
      if (resp) {
        _save();
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _note() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('NOTA', style: TextStyle(color: AppColors.success)),
        TextFormField(
          controller: controllerNote,
          maxLength: 200,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Añade notas o instrucciones sobre el ejercicio...',
            counterText: '',
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
        Row(
          spacing: 10,
          children: [
            DifficultWidget(
              selDiff: difficulty,
              diff: Difficulty.beginner,
              onTap: (value) => setState(() => difficulty = value),
            ),
            DifficultWidget(
              selDiff: difficulty,
              diff: Difficulty.intermediate,
              onTap: (value) => setState(() => difficulty = value),
            ),
            DifficultWidget(
              selDiff: difficulty,
              diff: Difficulty.advanced,
              onTap: (value) => setState(() => difficulty = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _equip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('EQUIPAMIENTO', style: TextStyle(color: AppColors.success)),
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: Equipment.values.length,
            itemBuilder: (BuildContext context, int index) {
              Equipment value = Equipment.values[index];
              return _equipment(value);
            },
            separatorBuilder: (BuildContext context, int index) => 10.w,
          ),
        ),
      ],
    );
  }

  Widget _type() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('TIPO DE EJERCICIO', style: TextStyle(color: AppColors.success)),
        Row(
          spacing: 10,
          children: [
            _exerciseType(
              ExerciseType.reps,
              Utils.iconReps,
              'Repeticiones',
              'Cuenta el número de repeticiones',
            ),
            _exerciseType(
              ExerciseType.time,
              Utils.iconTimer,
              'Tiempo',
              'Cuenta el tiempo del ejercicio',
            ),
          ],
        ),
      ],
    );
  }

  Widget _variants() {
    List<Exercise> variants = ExercisesExamples.fullList
        .where((e) => e.muscleGroup == muscleGroup)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('VARIANTES', style: TextStyle(color: AppColors.success)),
        if (variants.isEmpty)
          Align(alignment: Alignment.center, child: Text('Selecciona el grupo muscular')),
        ExercisesListWidget(
          exercises: variants,
          margin: 0,
          exercise: example,
          onSelect: (value) => setState(() {
            if (example == value) {
              example = null;
              equipment = Equipment.none;
              exerciseType = ExerciseType.reps;
            } else {
              example = value;
              equipment = example!.equipment;
              exerciseType = example!.type;
            }
          }),
        ),
      ],
    );
  }

  Widget _group() {
    List<MuscleGroup> values = [...MuscleGroup.values];
    values.sort((a, b) => a.displayName.compareTo(b.displayName));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('GRUPO MUSCULAR', style: TextStyle(color: AppColors.success)),
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              MuscleGroup value = values[index];
              return _muscle(value);
            },
            separatorBuilder: (BuildContext context, int index) => 10.w,
          ),
        ),
      ],
    );
  }

  Widget _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text('NOMBRE DEL EJERCICIO', style: TextStyle(color: AppColors.success)),
        TextFormField(
          controller: controllerName,
          maxLength: 50,
          decoration: InputDecoration(hintText: 'Ej: Flexiones', counterText: ''),
          onChanged: (value) => setState(() => ()),
        ),
      ],
    );
  }

  Widget _muscle(MuscleGroup value) {
    return Stack(
      children: [
        BounceableWidget(
          onTap: () => setState(() {
            if (muscleGroup == value) {
              muscleGroup = null;
            } else {
              muscleGroup = value;
            }
          }),
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: muscleGroup == value ? AppColors.success.withAlpha(30) : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: muscleGroup == value ? AppColors.success : Colors.grey[800]!,
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(value.assetName, width: 50, height: 50),
                  Text(value.displayName, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        if (muscleGroup == value)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
              child: Center(child: Icon(Utils.iconCheck, color: Colors.black, size: 20)),
            ),
          ),
      ],
    );
  }

  Widget _equipment(Equipment value) {
    return Stack(
      children: [
        BounceableWidget(
          onTap: () => setState(() => equipment = value),
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: equipment == value ? AppColors.success.withAlpha(30) : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: equipment == value ? AppColors.success : Colors.grey[800]!),
            ),
            child: Center(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(value.assetName, width: 50, height: 50),
                  Text(value.displayName, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        if (equipment == value)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
              child: Center(child: Icon(Utils.iconCheck, color: Colors.black, size: 20)),
            ),
          ),
      ],
    );
  }

  Widget _delete(BuildContext context) {
    if (exercise == null) return SizedBox.shrink();
    return Column(
      children: [
        Divider(color: AppColors.divider),
        GestureDetector(
          onTap: () async {
            if (gymProvider.canRemove(exercise!)) {
              final resp = await showMessage(
                context: context,
                message: '¿Eliminar el registro?',
                cancel: true,
              );
              if (resp && context.mounted) {
                gymProvider.removeExercise(exercise!);
                ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Ejercicio eliminado'));
                Navigator.of(context).pop();
              }
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(Utils.snackBar('No se puede borrar. Tiene datos', isBad: true));
            }
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
    );
  }

  void _save() {
    if (controllerName.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Indica el nombre del ejercicio', isBad: true));
      return;
    }
    if (muscleGroup == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Elige grupo muscular', isBad: true));
      return;
    }
    if (example == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(Utils.snackBar('Escoge una variante de ejercicio', isBad: true));
      return;
    }

    if (exercise == null) {
      exercise = Exercise(
        id: Uuid().v4(),
        name: controllerName.text,
        muscleGroup: muscleGroup!,
        difficulty: difficulty,
        equipment: equipment,
        image: example!.image,
        type: exerciseType,
        note: controllerNote.text,
      );
      gymProvider.addExercise(exercise!);
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Ejercicio guardado'));
    } else {
      exercise = Exercise(
        id: exercise!.id,
        name: controllerName.text,
        muscleGroup: muscleGroup!,
        difficulty: difficulty,
        equipment: equipment,
        image: example!.image,
        type: exerciseType,
        note: controllerNote.text,
      );
      gymProvider.updateExercise(exercise!);
      ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Ejercicio actualizado'));
    }
    Navigator.pop(context);
  }

  Widget _exerciseType(ExerciseType type, IconData icon, String title, String subtitle) {
    return Expanded(
      flex: 1,
      child: BounceableWidget(
        onTap: () {
          setState(() {
            exerciseType = type;
          });
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: exerciseType == type ? AppColors.success.withAlpha(30) : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: exerciseType == type ? AppColors.success : Colors.grey[800]!,
                ),
              ),
              child: Column(
                spacing: 10,
                children: [
                  Icon(icon, color: AppColors.success, size: 70),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(subtitle),
                ],
              ),
            ),
            if (exerciseType == type)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                  child: Center(child: Icon(Utils.iconCheck, color: Colors.black)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
