import 'package:flutter/material.dart';

class CountUp extends StatelessWidget {
  final int value;
  final Duration? duration;
  final TextStyle? style;

  const CountUp({super.key, required this.value, this.duration, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration ?? const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, animatedValue, child) {
        return Text(
          animatedValue.toInt().toString(),
          style: style ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
