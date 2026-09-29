import 'package:flutter/material.dart';

class VerticalDialCounter extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final double height;

  const VerticalDialCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 400),
    this.style,
    this.height = 80,
  });

  @override
  State<VerticalDialCounter> createState() => _VerticalDialCounterState();
}

class _VerticalDialCounterState extends State<VerticalDialCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentValue = 0;
  int _oldValue = 0;

  bool _goingUp = true;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;
    _oldValue = widget.value;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
  }

  @override
  void didUpdateWidget(covariant VerticalDialCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value == _currentValue) {
      return;
    }

    _oldValue = _currentValue;
    _currentValue = widget.value;

    _goingUp = _currentValue > _oldValue;

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final progress = _animation.value;

            final direction = _goingUp ? 1.0 : -1.0;

            final offset = widget.height * direction * progress;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Número anterior
                Transform.translate(
                  offset: Offset(0, offset),
                  child: Text(_oldValue.toString(), style: widget.style),
                ),

                // Número nuevo
                Transform.translate(
                  offset: Offset(0, offset + (widget.height * -direction)),
                  child: Text(_currentValue.toString(), style: widget.style),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
