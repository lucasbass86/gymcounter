import 'package:flutter/material.dart';
import 'package:gymcounter/widgets/_widget.dart';

class StatisticCardDurationWidget extends StatelessWidget {
  final Duration value;
  final String subtitle;
  final Color color;
  final IconData icon;
  final Duration? duration;
  const StatisticCardDurationWidget({
    super.key,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color),
            ),
            CountUpDuration(
              duration: value,
              animationDuration: duration,
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700),
            ),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
