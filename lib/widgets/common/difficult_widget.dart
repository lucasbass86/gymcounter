import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class DifficultWidget extends StatelessWidget {
  final Difficulty selDiff;
  final Difficulty diff;
  final Function(Difficulty) onTap;
  const DifficultWidget({
    super.key,
    required this.selDiff,
    required this.diff,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late String asset;
    late String title;
    switch (diff) {
      case Difficulty.beginner:
        asset = 'assets/dificultades/facil.png';
        title = 'Fácil';
        break;
      case Difficulty.intermediate:
        asset = 'assets/dificultades/medio.png';
        title = 'Medio';
        break;
      case Difficulty.advanced:
        asset = 'assets/dificultades/dificil.png';
        title = 'Difícil';
        break;
    }
    return Expanded(
      flex: 1,
      child: BounceableWidget(
        onTap: () => onTap.call(diff),
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selDiff == diff ? AppColors.success.withAlpha(30) : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selDiff == diff ? AppColors.success : Colors.grey[800]!),
              ),
              child: Column(
                children: [
                  Image.asset(asset, width: 70, height: 70),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (selDiff == diff)
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
