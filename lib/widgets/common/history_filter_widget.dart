import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/theme/appcolors.dart';

class HistoryFilterWidget extends StatefulWidget {
  final HistoryMode mode;
  final DateTime date;
  final Function(DateTime) onChange;
  const HistoryFilterWidget({
    super.key,
    required this.mode,
    required this.date,
    required this.onChange,
  });

  @override
  State<HistoryFilterWidget> createState() => _HistoryFilterWidgetState();
}

class _HistoryFilterWidgetState extends State<HistoryFilterWidget> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    String header = '', filter = '';
    switch (widget.mode) {
      case HistoryMode.day:
        header = 'Resumen diario';
        filter = Utils.dateEnglishToSpanish(widget.date);
        break;
      case HistoryMode.week:
        header = 'Resumen semanal';
        filter = Utils.week(widget.date, isSort: true);
        break;
      case HistoryMode.month:
        header = 'Resumen mensual';
        filter = Utils.monthName(widget.date.month);
        break;
      case HistoryMode.year:
        header = 'Resumen anual';
        filter = widget.date.year.toString();
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(header, style: TextStyle(fontSize: 17, color: Colors.white)),
        Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                switch (widget.mode) {
                  case HistoryMode.day:
                    date = widget.date.subtract(Duration(days: 1));
                    break;
                  case HistoryMode.week:
                    date = Utils.previousWeekSameDay(date);
                    break;
                  case HistoryMode.month:
                    date = Utils.getPreviousMonth(date);
                    break;
                  case HistoryMode.year:
                    date = Utils.getPreviousYear(date);
                    break;
                }
                // setState(() {});
                widget.onChange(date);
              },
              child: Icon(Utils.iconBack, color: AppColors.success),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(filter, style: TextStyle(color: AppColors.success)),
            ),
            GestureDetector(
              onTap: () {
                switch (widget.mode) {
                  case HistoryMode.day:
                    date = date.subtract(Duration(days: -1));
                    break;
                  case HistoryMode.week:
                    date = Utils.previousWeekSameDay(date, isNext: true);
                    break;
                  case HistoryMode.month:
                    date = Utils.getPreviousMonth(date, isNext: true);
                    break;
                  case HistoryMode.year:
                    date = Utils.getPreviousYear(date, isNext: true);
                    break;
                }
                // setState(() {});
                widget.onChange(date);
              },
              child: Icon(Utils.iconForward, color: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }
}
