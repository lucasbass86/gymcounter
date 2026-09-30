import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/widgets/_widget.dart';

class TargetWidget extends StatelessWidget {
  final Target target;
  const TargetWidget({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    return BounceableWidget(
      onTap: () => Navigator.pushNamed(
        context,
        WorkoutsListPage.routeName,
        arguments: [HistoryMode.day, target.date],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Utils.dateEnglishToSpanish(target.date)),
              Text('${target.value} de ${target.target}'),
              Row(
                spacing: 10,
                children: [
                  CircularProgressWidget(
                    currentValue: target.value,
                    totalValue: target.target,
                    progressColor: Utils.progressColor(target.value, target.target),
                  ),
                  Icon(Utils.iconForward),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
