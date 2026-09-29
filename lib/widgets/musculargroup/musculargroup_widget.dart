import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/widgets/_widget.dart';

class MusculargroupWidget extends StatelessWidget {
  final MuscleGroup muscleGroup;
  final VoidCallback onTap;
  const MusculargroupWidget({super.key, required this.muscleGroup, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(muscleGroup.assetName, width: 50, height: 50),
            Text(muscleGroup.displayName, style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
