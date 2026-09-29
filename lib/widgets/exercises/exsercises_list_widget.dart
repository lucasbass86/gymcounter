import 'package:flutter/material.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ExercisesListWidget extends StatelessWidget {
  final List<Exercise> exercises;
  final double margin;
  final Exercise? exercise;
  final Function(Exercise)? onSelect;
  const ExercisesListWidget({
    super.key,
    required this.exercises,
    this.margin = 60,
    this.exercise,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) => BasicExerciseWidget(
        exercise: exercises[index],
        margin: margin,
        isSelected: exercise == exercises[index],
        onSelect: (value) => onSelect?.call(value),
      ),
      separatorBuilder: (BuildContext context, int index) => Container(
        margin: EdgeInsets.only(left: margin),
        child: Divider(color: AppColors.divider),
      ),
    );
  }
}
