import 'package:flutter/material.dart';

class CountUpDuration extends StatelessWidget {
  final Duration duration;
  final Duration? animationDuration;
  final TextStyle? style;

  const CountUpDuration({super.key, required this.duration, this.animationDuration, this.style});

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = duration.inSeconds.toDouble();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: totalSeconds),
      duration: animationDuration ?? const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) {
        final current = Duration(seconds: animatedValue.toInt());
        return Text(
          _format(current),
          style: style ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
