import 'package:flutter/material.dart';

class VerticalDialDigit extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final double height;

  const VerticalDialDigit({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 350),
    this.style,
    this.height = 74,
  });

  @override
  State<VerticalDialDigit> createState() => _VerticalDialDigitState();
}

class _VerticalDialDigitState extends State<VerticalDialDigit> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late int _oldValue;
  late int _currentValue;

  bool _isIncrement = true;

  @override
  void initState() {
    super.initState();

    _oldValue = widget.value;
    _currentValue = widget.value;

    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant VerticalDialDigit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value == _currentValue) {
      return;
    }

    _oldValue = _currentValue;
    _currentValue = widget.value;

    _isIncrement = _currentValue > _oldValue;

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const TextStyle(fontSize: 48, fontWeight: FontWeight.bold);

    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          builder: (context, child) {
            final progress = _controller.value;

            final direction = _isIncrement ? -1.0 : 1.0;

            // Distancia que recorre el número.
            final distance = widget.height * 0.65;

            final oldOffset = direction * distance * progress;

            final newOffset = direction * distance * progress - direction * distance;

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, oldOffset),
                  child: Text(_formatValue(_oldValue), style: style),
                ),

                Transform.translate(
                  offset: Offset(0, newOffset),
                  child: Text(_formatValue(_currentValue), style: style),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatValue(int value) {
    return value.toString().padLeft(2, '0');
  }
}

class DurationDialCounter extends StatelessWidget {
  final Duration duration;
  final Duration animationDuration;
  final TextStyle? style;
  final double spacing;

  const DurationDialCounter({
    super.key,
    required this.duration,
    this.animationDuration = const Duration(milliseconds: 350),
    this.style,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VerticalDialDigit(value: hours, duration: animationDuration, style: style),
        Text(':', style: style),
        // SizedBox(width: spacing),
        VerticalDialDigit(value: minutes, duration: animationDuration, style: style),
        Text(':', style: style),
        // SizedBox(width: spacing),
        VerticalDialDigit(value: seconds, duration: animationDuration, style: style),
      ],
    );
  }
}
