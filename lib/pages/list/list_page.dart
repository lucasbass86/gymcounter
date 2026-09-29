import 'package:flutter/material.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ListPage extends StatelessWidget {
  static const String routeName = 'ListPage';
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(appBar: _appBar(context, (list as List).length), body: _child(list));
  }

  AppBar _appBar(BuildContext context, int numOfItems) {
    return AppBar(
      centerTitle: false,
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Listado')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Text(
            numOfItems == 1 ? '1 registro' : '$numOfItems registros',
            style: TextStyle(color: AppColors.success),
          ),
        ),
      ],
    );
  }

  Widget _child(final list) {
    if (list is List<Workout>) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) => WorkoutWidget(workout: list[index]),
      );
    } else if (list is List) {
      final workouts = list[0] as List<Workout>;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: workouts.length,
        itemBuilder: (BuildContext context, int index) {
          final Workout w = workouts[index];
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: w.exercisesSet.length,
            itemBuilder: (BuildContext context, int index) {
              return RecentExerciseWidget(set: w.exercisesSet[index], workout: w);
            },
          );
        },
      );
    } else if (list is List<Measurement>) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return MeasurementWidget(measurement: list[index]);
        },
      );
    }
    return Text('No controlado');
  }
}
