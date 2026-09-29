import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class ButtonSaveWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData? icon;
  final Color? backColor;
  final double? scaleFactor;
  const ButtonSaveWidget({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
    this.backColor,
    this.scaleFactor = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      scaleFactorOnTap: scaleFactor,
      onTap: () => onTap.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        decoration: BoxDecoration(
          color: backColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(icon ?? Utils.iconSave, color: Colors.black),
            Text(title, style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
