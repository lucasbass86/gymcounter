import 'package:flutter/material.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class CircularButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;
  final Function onTap;
  final bool isCircle;
  final double scaleFactorOnTap;
  const CircularButtonWidget({
    super.key,
    required this.width,
    required this.height,
    required this.iconData,
    required this.onTap,
    this.isCircle = true,
    this.scaleFactorOnTap = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      scaleFactorOnTap: scaleFactorOnTap,
      onTap: () => onTap.call(),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: !isCircle ? BorderRadius.circular(16) : null,
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}
