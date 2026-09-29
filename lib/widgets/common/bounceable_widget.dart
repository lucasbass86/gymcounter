import 'package:bounceable/bounceable.dart';
import 'package:flutter/material.dart';

class BounceableWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? scaleFactorOnTap;
  const BounceableWidget({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleFactorOnTap = 0.95,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      onLongPress: onLongPress,
      scaleFactorOnTap: scaleFactorOnTap!,
      child: child,
    );
  }
}
