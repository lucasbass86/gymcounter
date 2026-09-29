import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class WorkoutsListPage extends StatefulWidget {
  static const String routeName = 'WorkoutsListPage';
  const WorkoutsListPage({super.key});

  @override
  State<WorkoutsListPage> createState() => _WorkoutsListPageState();
}

class _WorkoutsListPageState extends State<WorkoutsListPage> {
  late GymProvider gymProvider;
  DateTime date = DateTime.now();
  HistoryMode mode = Utils.getHistoryModeByIndex(Preferences.indexTabWorkouts);
  List<Workout> workouts = [];
  Rutine? rutine;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Rutine) {
        rutine = arguments;
      } else if (arguments is List) {
        mode = arguments[0] as HistoryMode;
        date = arguments[1] as DateTime;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context);
    workouts = gymProvider.getWorkoutsByHistory(mode, date)
      ..sort((a, b) => b.date.compareTo(a.date));
    if (rutine != null) {
      workouts = workouts.where((w) => w.idRutine == rutine!.id).toList();
    }
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            HistoryModesWidget(
              mode: mode,
              onTap: (value) {
                Preferences.indexTabWorkouts = Utils.getIndexByHistoryMode(value);
                setState(() => mode = value);
              },
            ),
            20.h,
            HistoryFilterWidget(
              mode: mode,
              date: date,
              onChange: (value) {
                setState(() => date = value);
              },
            ),
            20.h,
            Expanded(
              child: workouts.isEmpty
                  ? Icon(Utils.iconFire, color: AppColors.divider, size: 150)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: workouts.length,
                      itemBuilder: (BuildContext context, int index) =>
                          WorkoutWidget(workout: workouts[index]),
                    ),
            ),
            ButtonSaveWidget(
              onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName, arguments: true),
              title: 'Nuevo workout',
              icon: Utils.iconFire,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Workouts')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Text(
            workouts.length == 1 ? '1 ejercicio' : '${workouts.length} ejercicios',
            style: TextStyle(color: AppColors.success),
          ),
        ),
        IconButton(
          tooltip: 'Mostrar todo',
          onPressed: () =>
              Navigator.pushNamed(context, ListPage.routeName, arguments: gymProvider.workouts),
          icon: Icon(Utils.iconDumbbell),
        ),
      ],
    );
  }
}
