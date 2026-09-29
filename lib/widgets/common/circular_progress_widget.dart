import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class CircularProgressWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final int currentValue;
  final int totalValue;
  final double? size;
  final double? strokeWidthInner;
  final double? strokeWidthOutter;
  final double? fontSize;
  final bool showPercent;
  final Widget? action;
  final bool isTime;
  const CircularProgressWidget({
    super.key,
    this.backgroundColor,
    this.progressColor,
    required this.currentValue,
    required this.totalValue,
    this.size,
    this.strokeWidthInner,
    this.strokeWidthOutter,
    this.fontSize,
    this.showPercent = true,
    this.action,
    this.isTime = false,
  });

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: currentValue);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: backgroundColor ?? AppColors.divider,
            value: 1,
            strokeWidth: strokeWidthInner ?? 2,
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: progressColor ?? AppColors.success,
            value: totalValue == 0 ? 0 : currentValue / totalValue,
            strokeWidth: strokeWidthOutter ?? 3,
          ),
        ),
        if (showPercent)
          Column(
            children: [
              Text(
                '${totalValue == 0 ? 0 : ((currentValue / totalValue) * 100).round()}%',
                style: TextStyle(fontSize: fontSize ?? 11, color: Colors.white),
              ),
              if (action != null) action!,
            ],
          ),
        if (!showPercent)
          Column(
            children: [
              if (!isTime)
                VerticalDialCounter(
                  value: currentValue,
                  style: TextStyle(fontSize: fontSize ?? 11, color: Colors.white),
                ),
              if (isTime)
                Text(
                  Utils.durationToString(duration, showSeconds: true, showZeroHour: true),
                  style: TextStyle(fontSize: fontSize ?? 11, color: Colors.white),
                ),
              if (action != null) action!,
            ],
          ),
      ],
    );
  }
}
