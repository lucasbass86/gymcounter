import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class HistoryModesWidget extends StatelessWidget {
  final HistoryMode mode;
  final Function(HistoryMode) onTap;
  final bool withDay;
  const HistoryModesWidget({
    super.key,
    required this.mode,
    required this.onTap,
    this.withDay = true,
  });

  @override
  Widget build(BuildContext context) {
    List<HistoryMode> values = [...HistoryMode.values];
    if (!withDay) {
      values.remove(HistoryMode.day);
    }
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(
        spacing: 10,
        children: [
          ...values.map((val) {
            return Flexible(
              flex: 1,
              child: BounceableWidget(
                scaleFactorOnTap: 1.2,
                onTap: () => onTap.call(val),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: val == mode ? AppColors.success : AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(val.displayName, style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
