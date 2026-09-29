import 'package:flutter/material.dart';
import 'package:gymcounter/theme/appcolors.dart';

class BasicContainerWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color? backColor;
  const BasicContainerWidget({
    super.key,
    required this.child,
    this.height = 55,
    this.width = 110,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: backColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: child),
    );
  }
}
