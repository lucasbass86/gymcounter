import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class BasicExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  final double margin;
  final bool isSelected;
  final Function(Exercise)? onSelect;
  const BasicExerciseWidget({
    super.key,
    required this.exercise,
    this.margin = 60,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      onTap: () => onSelect?.call(exercise),
      onLongPress: () => showImage(context, exercise.image),
      child: Container(
        margin: EdgeInsets.only(left: margin, bottom: 10),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(exercise.image, width: 50, height: 50),
            Expanded(child: Text(exercise.name)),
            if (isSelected)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                child: Center(child: Icon(Utils.iconCheck, color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}
