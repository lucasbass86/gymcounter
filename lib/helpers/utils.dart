import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/theme/appcolors.dart';

class Utils {
  //
  //WEIGHT
  //
  static const List<int> weightDays = [1, 2, 3, 4, 5, 6, 7, 10, 15, 20, 30];
  static const List<int> daysForRecentExercises = [3, 5, 7, 10];
  //
  // COLORS
  //
  static const List<Color> appColors = [
    Color(0xFF2196F3), // Azul (principal)
    Color(0xFF00BCD4), // Cian
    Color(0xFF26C6DA), // Turquesa
    Color(0xFF26A69A), // Verde azulado

    Color(0xFF43A047), // Verde
    Color(0xFF66BB6A), // Verde claro
    Color(0xFF8BC34A), // Lima
    Color(0xFFFFC107), // Ámbar

    Color(0xFFFF9800), // Naranja
    Color(0xFFFF7043), // Naranja intenso
    Color(0xFFE53935), // Rojo
    Color(0xFFEC407A), // Rosa

    Color(0xFFAB47BC), // Morado
    Color(0xFF7E57C2), // Violeta
    Color(0xFF5C6BC0), // Índigo
    Color(0xFF78909C), // Azul grisáceo
  ];

  //
  // ICONS
  //
  static const IconData iconHome = Icons.home_rounded;
  static const IconData iconPie = Icons.bar_chart_rounded;
  static const IconData iconStatistics = Icons.pie_chart_rounded;
  static const IconData iconSettings = Icons.settings_sharp;
  static const IconData iconFire = Icons.local_fire_department;
  static const IconData iconForward = Icons.arrow_forward_ios_rounded;
  static const IconData iconBack = Icons.arrow_back_ios_rounded;
  static const IconData iconSave = Icons.save_rounded;
  static const IconData iconAdd = Icons.add_rounded;
  static const IconData iconRemove = Icons.remove_rounded;
  static const IconData iconDelete = Icons.delete_rounded;
  static const IconData iconClose = Icons.close_rounded;
  static const IconData iconCheck = Icons.check_rounded;
  static const IconData iconEdit = Icons.edit_rounded;
  static const IconData iconCalendar = Icons.calendar_month_rounded;
  static const IconData iconTimer = Icons.timer_sharp;
  static const IconData iconPlay = Icons.play_arrow_rounded;
  static const IconData iconPause = Icons.pause_rounded;
  static const IconData iconStop = Icons.stop_rounded;
  static const IconData iconReps = Icons.sync_rounded;
  static const IconData iconUP = Icons.arrow_drop_up_rounded;
  static const IconData iconDown = Icons.arrow_drop_down_rounded;
  static const IconData iconEquals = Icons.drag_handle;
  static const IconData iconDumbbell = Icons.fitness_center_rounded;
  static const IconData iconWeight = Icons.monitor_weight_rounded;
  static const IconData iconHeight = Icons.straighten;
  static const IconData iconObesity = Icons.keyboard_double_arrow_up_rounded;
  static const IconData iconInfo = Icons.info_outline_rounded;
  static const IconData iconMenu = Icons.more_vert_rounded;
  static const IconData iconCopy = Icons.copy_rounded;
  static const IconData iconRecors = Icons.emoji_events_rounded;
  static const IconData iconBest = Icons.workspace_premium;
  static const IconData iconHistory = Icons.history_rounded;
  static const IconData iconGraphic = Icons.ssid_chart_rounded;
  static const IconData iconList = Icons.list_rounded;
  static const IconData iconGrouped = Icons.account_tree_rounded;
  static const IconData iconRestart = Icons.restart_alt_rounded;

  static Color progressColor(int reps, int total) {
    if (total == 0) return AppColors.error;
    int percent = (reps / total * 100).round();
    if (percent < 25) {
      return AppColors.error;
    } else if (percent < 50) {
      return AppColors.warning;
    } else if (percent < 75) {
      return AppColors.primaryDark;
    } else {
      return AppColors.success;
    }
  }

  //
  //SNACKBAR
  //
  static SnackBar snackBar(String text, {Color? color, bool isBad = false}) {
    return SnackBar(
      content: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: isBad ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  static void snackBarOverlay(
    BuildContext context,
    String message, {
    bool isGood = true,
    bool hideKeyboard = true,
  }) {
    final overlay = Overlay.of(context);
    OverlayEntry entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isGood ? Colors.green[200] : Colors.red[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message, style: TextStyle(color: isGood ? Colors.white : Colors.black)),
          ),
        ),
      ),
    );

    if (hideKeyboard) FocusScope.of(context).unfocus();
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }

  //
  //DATES
  //
  static String getInitialEndMonth(DateTime date) {
    int ultimoDiaMes = DateTime(date.year, date.month + 1, 0).day;
    return '1-$ultimoDiaMes ${monthName(date.month)} ${date.year}';
  }

  static DateTime getPreviousMonth(DateTime date, {bool isNext = false}) {
    int month = isNext ? date.month + 1 : date.month - 1;
    DateTime mes = DateTime(date.year, month, date.day);
    return mes;
  }

  static DateTime getPreviousYear(DateTime date, {bool isNext = false}) {
    int year = isNext ? date.year + 1 : date.year - 1;
    DateTime anio = DateTime(year, date.month, date.day);
    return anio;
  }

  static String dateEnglishToSpanish(
    DateTime dateTime, {
    bool showTime = false,
    bool shortYear = false,
  }) {
    String date = dateTime.toString();
    String year = shortYear ? date.substring(2, 4) : date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else if (date.length > 10) {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      // String seconds = date.substring(17, 19);
      return "$day-$month-$year $hour:$minute";
    } else {
      return "$day-$month-$year 00:00";
    }
  }

  static String shortdateEnglishToSpanish(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    return "$day ${monthName(int.parse(month), isSort: true)} $year";
  }

  static String getNombreDia(DateTime fecha, {DayFormat format = DayFormat.full}) {
    const full = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const short = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const letter = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    switch (format) {
      case DayFormat.full:
        return full[fecha.weekday - 1];
      case DayFormat.short:
        return short[fecha.weekday - 1];
      case DayFormat.letter:
        return letter[fecha.weekday - 1];
    }
  }

  static String monthName(int month, {bool isSort = false}) {
    switch (month) {
      case 1:
        return isSort ? 'Ene' : 'Enero';
      case 2:
        return isSort ? 'Feb' : 'Febrero';
      case 3:
        return isSort ? 'Mar' : 'Marzo';
      case 4:
        return isSort ? 'Abr' : 'Abril';
      case 5:
        return isSort ? 'May' : 'Mayo';
      case 6:
        return isSort ? 'Jun' : 'Junio';
      case 7:
        return isSort ? 'Jul' : 'Julio';
      case 8:
        return isSort ? 'Ago' : 'Agosto';
      case 9:
        return isSort ? 'Sep' : 'Septiembre';
      case 10:
        return isSort ? 'Oct' : 'Octubre';
      case 11:
        return isSort ? 'Nov' : 'Noviembre';
      case 12:
        return isSort ? 'Dic' : 'Diciembre';
      default:
        return '';
    }
  }

  static String week(DateTime current, {bool isSort = false}) {
    String week = '';
    DateTime dateStart = current.subtract(Duration(days: current.weekday - 1));
    DateTime dateEnd = dateStart.add(const Duration(days: 6));
    String start =
        '${dateStart.day.toString().padLeft(2, '0')} ${dateStart.month != dateEnd.month ? monthName(dateStart.month, isSort: isSort) : ''}';
    String end = dateEnd.day.toString().padLeft(2, '0');
    week = '$start - $end ${Utils.monthName(dateEnd.month, isSort: isSort)} ${current.year}';
    return week;
  }

  static bool isInSameWeek(DateTime date, {DateTime? reference}) {
    final ref = reference ?? DateTime.now();
    // Lunes de la semana de referencia
    final weekStart = ref.subtract(Duration(days: ref.weekday - 1));
    // Normalizar fechas
    final d1 = DateTime(date.year, date.month, date.day);
    final d2 = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final difference = d1.difference(d2).inDays;
    return difference >= 0 && difference <= 6;
  }

  static bool isInSameMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static bool isInSameYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  static DateTime previousWeekSameDay(DateTime date, {bool isNext = false}) {
    final monday = date.subtract(Duration(days: date.weekday - DateTime.monday));
    return monday.subtract(Duration(days: isNext ? -7 : 7));
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && date.day == now.day;
  }

  static bool fechaMenorOIgual(DateTime from, {int dias = 3}) {
    final hoy = DateTime.now();
    final soloFechaHoy = DateTime(hoy.year, hoy.month, hoy.day);
    final limiteInferior = soloFechaHoy.subtract(Duration(days: dias));
    final soloFecha = DateTime(from.year, from.month, from.day);
    return soloFecha.isAfter(limiteInferior) ||
        soloFecha.isAtSameMomentAs(limiteInferior) &&
            (soloFecha.isBefore(soloFechaHoy) || soloFecha.isAtSameMomentAs(soloFechaHoy));
  }

  //
  // TIME OF DAY
  //
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay addTimeOfDay(TimeOfDay a, TimeOfDay b) {
    final int minutosA = a.hour * 60 + a.minute;
    final int minutosB = b.hour * 60 + b.minute;

    final int total = minutosA + minutosB;

    final int horas = (total ~/ 60) % 24;
    final int minutos = total % 60;

    return TimeOfDay(hour: horas, minute: minutos);
  }

  static TimeOfDay durationToTimeOfDay(Duration d) {
    final int totalMin = d.inMinutes;
    final int hour = (totalMin ~/ 60) % 24;
    final int minute = totalMin % 60;

    return TimeOfDay(hour: hour, minute: minute);
  }

  //
  // DURATION
  //
  static String durationToString(
    Duration duration, {
    bool showSeconds = true,
    bool showZeroHour = false,
  }) {
    final hh = duration.inHours;
    final mm = duration.inMinutes % 60;
    final ss = duration.inSeconds % 60;
    return '${hh > 0 || showZeroHour ? '${hh.toString().padLeft(2, '0')}:' : ''}${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
    // return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
  }

  static String minutesDurationToString(Duration duration) {
    final mm = duration.inMinutes;
    return mm.toString().padLeft(2, '0');
  }

  static String secondsDurationToString(Duration duration) {
    final ss = duration.inSeconds % 60;
    return ss.toString().padLeft(2, '0');
  }

  static int secondsDuration(Duration duration) {
    final ss = duration.inSeconds % 60;
    return ss;
  }

  static Duration acumularTimeOfDay(List<TimeOfDay> tiempos) {
    int totalMinutos = 0;
    for (final t in tiempos) {
      totalMinutos += t.hour * 60 + t.minute;
    }
    return Duration(minutes: totalMinutos);
  }

  static Duration acumularDurations(List<Duration> tiempos) {
    int totalSegundos = 0;
    for (final d in tiempos) {
      totalSegundos += d.inSeconds;
    }
    return Duration(seconds: totalSegundos);
  }

  //
  // PACE
  //
  String? validatePace(String? value) {
    final paceRegex = RegExp(r'^[0-5]\d:[0-5]\d$');
    if (value == null || value.isEmpty) {
      return 'Ingresa un ritmo';
    }
    if (!paceRegex.hasMatch(value)) {
      return 'Formato inválido. Usa MM:SS';
    }
    return null;
  }

  Duration parsePace(String value) {
    final parts = value.split(':');
    final mm = int.parse(parts[0]);
    final ss = int.parse(parts[1]);
    return Duration(minutes: mm, seconds: ss);
  }

  //
  // TEXT
  //
  static Size getTextSize(String text, TextStyle style, {double maxWidth = double.infinity}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }

  //
  // IMC
  //
  static double calcularIMC({required double weight, required double height}) {
    if (height <= 0) return 0;
    return weight / (height * height);
  }

  //
  // CONNECTION
  //
  static bool isConnected = false;
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.es');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
        return true;
      } else {
        isConnected = false;
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  //json
  static String timeOfDayToJson(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  static TimeOfDay timeOfDayFromJson(String s) {
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static Duration timeOfDayFromJsonToDuration(String s) {
    final parts = s.split(':');
    return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
  }

  ///
  ///HISTORYMODE
  ///
  static HistoryMode getHistoryModeByIndex(int index) {
    switch (index) {
      case 0:
        return HistoryMode.day;
      case 1:
        return HistoryMode.week;
      case 2:
        return HistoryMode.month;
      case 3:
        return HistoryMode.year;
      default:
        return HistoryMode.day;
    }
  }

  static int getIndexByHistoryMode(HistoryMode mode) {
    switch (mode) {
      case HistoryMode.day:
        return 0;
      case HistoryMode.week:
        return 1;
      case HistoryMode.month:
        return 2;
      case HistoryMode.year:
        return 3;
    }
  }

  ///
  ///PORCENTAJES
  ///
  static double getPercent(int previous, int now) {
    if (previous == 0) {
      return now == 0 ? 0 : 100;
    }
    return ((now - previous) / previous) * 100;
  }
}
