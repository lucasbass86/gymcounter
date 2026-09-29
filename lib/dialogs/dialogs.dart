import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/theme/appcolors.dart';

Future<dynamic> showMessage({
  required BuildContext context,
  required String message,
  String secondMessage = '',
  bool hideTitle = false,
  bool cancel = false,
  String? acceptText,
  String? cancelText,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: !hideTitle ? Text("Información") : SizedBox.shrink(),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              if (secondMessage.isNotEmpty) Text(secondMessage, style: TextStyle(fontSize: 19)),
            ],
          ),
        ),
        actions: [
          if (cancel)
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelText ?? 'Cancelar'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(acceptText ?? 'Aceptar'),
          ),
        ],
      );
    },
  ).then((onValue) => onValue);
}

Future<dynamic> showInput(
  BuildContext context,
  String title, {
  String? value,
  TextInputType? inputType,
}) {
  TextEditingController controller = TextEditingController(text: value ?? '');
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, setState) {
            return TextFormField(
              onChanged: (p) {
                if (p.isNotEmpty) value = p;
              },
              controller: controller,
              decoration: InputDecoration(filled: true, counterText: ''),
              maxLength: 50,
              textCapitalization: TextCapitalization.words,
              keyboardType: inputType ?? TextInputType.none,
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop([false]),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) {
                Utils.snackBarOverlay(context, 'Indica la información', isGood: false);
                return;
              }
              Navigator.of(dialogContext).pop([true, controller.text]);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  ).then((onValue) => onValue ?? [false]);
}

Future<DateTime?> showDate(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  String? title,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(1986, 4, 21),
    lastDate: DateTime(DateTime.now().year, 12, 31),
    cancelText: 'Cancelar',
    confirmText: 'Aceptar',
    helpText: title ?? 'Indica la fecha',
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
}

Future<bool> showSlideToUnlock(
  BuildContext context, {
  Color backColor = const Color.fromRGBO(224, 224, 224, 1),
  Color slideColor = Colors.blue,
  Color slideColorEnd = Colors.green,
  String text = 'Desliza para confirmar',
  Color textColor = Colors.white,
  IconData iconData = Icons.arrow_forward,
}) async {
  final unlocked = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      double offset = 0.0;
      bool unlocked0 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          final width = MediaQuery.of(context).size.width - 32;
          final maxOffset = width - 80;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 1.0 - (offset / maxOffset),
                        child: Text(text, style: TextStyle(color: textColor)),
                      ),
                    ),
                    Positioned(
                      left: offset,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            offset += details.delta.dx;
                            if (offset < 0) offset = 0;
                            if (offset > maxOffset) offset = maxOffset;
                          });
                        },
                        onHorizontalDragEnd: (_) {
                          if (offset > maxOffset * 0.9) {
                            setState(() {
                              unlocked0 = true;
                              offset = maxOffset;
                            });
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {
                              offset = 0;
                            });
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: unlocked0 ? slideColorEnd : slideColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: unlocked0
                              ? Icon(Icons.check_rounded, color: Colors.white)
                              : Icon(iconData, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return unlocked == true;
}

Future<void> showImage(BuildContext context, String assetName) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(assetName, fit: BoxFit.contain),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return Transform.scale(scale: anim.value, child: child);
    },
  );
}

Future<Duration?> showPacePicker({
  required BuildContext context,
  Duration initialPace = const Duration(hours: 0, minutes: 0, seconds: 0),
  String? title,
  String? acceptText,
  String? cancelText,
  bool hasHours = false,
}) {
  int selectedHours = initialPace.inHours;
  int selectedMinutes = initialPace.inMinutes % 60;
  int selectedSeconds = initialPace.inSeconds % 60;

  return showDialog<Duration>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 330,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title ?? 'Selecciona ritmo (MM:SS)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    if (hasHours)
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha((255 * 0.10).toInt()),
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                  ),
                                  bottom: BorderSide(
                                    color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                  ),
                                ),
                              ),
                            ),
                            ListWheelScrollView.useDelegate(
                              itemExtent: 40,
                              perspective: 0.002,
                              physics: const FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(initialItem: selectedHours),
                              onSelectedItemChanged: (value) {
                                selectedHours = value;
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  if (index < 0 || index > 23) return null;
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (hasHours) const Text(":", style: TextStyle(fontSize: 22)),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha((255 * 0.10).toInt()),
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                ),
                                bottom: BorderSide(
                                  color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                ),
                              ),
                            ),
                          ),
                          ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.002,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(initialItem: selectedMinutes),
                            onSelectedItemChanged: (value) {
                              selectedMinutes = value;
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index > 59) return null;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(":", style: TextStyle(fontSize: 22)),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha((255 * 0.10).toInt()),
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: AppColors.primary.withAlpha((255 * 0.35).toInt()),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.002,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(initialItem: selectedSeconds),
                            onSelectedItemChanged: (value) {
                              selectedSeconds = value;
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index > 59) return null;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelText ?? 'Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        Duration(
                          hours: selectedHours,
                          minutes: selectedMinutes,
                          seconds: selectedSeconds,
                        ),
                      );
                    },
                    child: Text(acceptText ?? 'Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> showAddWeight(BuildContext context, {Measurement? measurement, String? title}) {
  DateTime date = measurement?.date ?? DateTime.now();
  TextEditingController controller = TextEditingController(text: measurement?.weight.toString());
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title ?? 'Introduce los datos del peso'),
        content: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final resp = await showDate(context, initialDate: date);
                      if (resp != null) {
                        date = resp;
                        setState(() => ());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Utils.iconCalendar),
                          Text(
                            Utils.dateEnglishToSpanish(date),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    maxLength: 6,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Utils.iconWeight),
                      counterText: '',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context, [false]), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) {
                Utils.snackBarOverlay(context, 'Introduce el peso', isGood: false);
              }
              Navigator.pop(context, [true, date, double.parse(controller.text)]);
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
