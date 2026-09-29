import 'package:flutter/material.dart';

enum MuscleGroup {
  back,
  biceps,
  calfs,
  cardio,
  chest,
  core,
  forearms,
  funtionals,
  glutes,
  hamstrings,
  legs,
  lumbar,
  mobility,
  shoulders,
  triceps,
  various,
  relax,
  balance,
}

extension MuscleGroupEx on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Pecho';
      case MuscleGroup.back:
        return 'Espalda';
      case MuscleGroup.shoulders:
        return 'Hombros';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.forearms:
        return 'Antebrazos';
      case MuscleGroup.legs:
        return 'Piernas';
      case MuscleGroup.glutes:
        return 'Glúetos';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.cardio:
        return 'Cardio';
      case MuscleGroup.mobility:
        return 'Movilidad';
      case MuscleGroup.calfs:
        return 'Gemelos';
      case MuscleGroup.funtionals:
        return 'Funcional';
      case MuscleGroup.hamstrings:
        return 'Isquios';
      case MuscleGroup.lumbar:
        return 'Lumbares';
      case MuscleGroup.various:
        return 'Varios';
      case MuscleGroup.relax:
        return 'Relax';
      case MuscleGroup.balance:
        return 'Equilibrio';
    }
  }

  String get assetName {
    switch (this) {
      case MuscleGroup.chest:
        return 'assets/iconos/pecho.png';
      case MuscleGroup.back:
        return 'assets/iconos/espalda.png';
      case MuscleGroup.shoulders:
        return 'assets/iconos/hombros.png';
      case MuscleGroup.biceps:
        return 'assets/iconos/biceps.png';
      case MuscleGroup.triceps:
        return 'assets/iconos/triceps.png';
      case MuscleGroup.forearms:
        return 'assets/iconos/antebrazos.png';
      case MuscleGroup.legs:
        return 'assets/iconos/piernas.png';
      case MuscleGroup.glutes:
        return 'assets/iconos/gluteos.png';
      case MuscleGroup.core:
        return 'assets/iconos/abdominales.png';
      case MuscleGroup.cardio:
        return 'assets/iconos/cardio.png';
      case MuscleGroup.mobility:
        return 'assets/iconos/movilidad.png';
      case MuscleGroup.calfs:
        return 'assets/iconos/gemelos.png';
      case MuscleGroup.funtionals:
        return 'assets/iconos/cuerpo.png';
      case MuscleGroup.hamstrings:
        return 'assets/iconos/isquiotibiales.png';
      case MuscleGroup.lumbar:
        return 'assets/iconos/lumbar.png';
      case MuscleGroup.various:
        return 'assets/iconos/varios.png';
      case MuscleGroup.relax:
        return 'assets/iconos/relax.png';
      case MuscleGroup.balance:
        return 'assets/iconos/balance.png';
    }
  }

  Color get color {
    switch (this) {
      case MuscleGroup.back:
        return Color(0xFF2196F3);
      case MuscleGroup.biceps:
        return Color(0xFF00BCD4);
      case MuscleGroup.calfs:
        return Color(0xFF26C6DA);
      case MuscleGroup.cardio:
        return Color(0xFF26A69A);
      case MuscleGroup.chest:
        return Color(0xFF43A047);
      case MuscleGroup.core:
        return Color(0xFF66BB6A);
      case MuscleGroup.forearms:
        return Color(0xFF8BC34A);
      case MuscleGroup.funtionals:
        return Color(0xFFFFC107);
      case MuscleGroup.glutes:
        return Color(0xFFFF9800);
      case MuscleGroup.hamstrings:
        return Color(0xFFFF7043);
      case MuscleGroup.legs:
        return Color(0xFFE53935);
      case MuscleGroup.lumbar:
        return Color(0xFFEC407A);
      case MuscleGroup.mobility:
        return Color(0xFFAB47BC);
      case MuscleGroup.shoulders:
        return Color(0xFF7E57C2);
      case MuscleGroup.triceps:
        return Color(0xFF5C6BC0);
      case MuscleGroup.various:
        return Color.fromARGB(255, 131, 13, 167);
      case MuscleGroup.relax:
        return Color.fromARGB(255, 243, 200, 144);
      case MuscleGroup.balance:
        return Color.fromARGB(255, 160, 124, 78);
    }
  }
}

enum Equipment {
  none,
  bodyweight,
  dumbbells,
  barbell,
  kettlebell,
  machine,
  resistanceBand,
  rope,
  plate,
  battleRope,
  plyometricBox,
  roller,
  abWheel,
  sandBag,
  bag,
  ball,
  handgrip,
  wallball,
}

extension EquipmentEx on Equipment {
  String get displayName {
    switch (this) {
      case Equipment.none:
        return 'Nada';
      case Equipment.bodyweight:
        return 'Peso';
      case Equipment.dumbbells:
        return 'Mancuerna';
      case Equipment.barbell:
        return 'Barras';
      case Equipment.kettlebell:
        return 'Kettlebell';
      case Equipment.machine:
        return 'Máquina';
      case Equipment.resistanceBand:
        return 'Banda';
      case Equipment.rope:
        return 'Comba';
      case Equipment.plate:
        return 'Disco';
      case Equipment.battleRope:
        return 'Cuerda';
      case Equipment.plyometricBox:
        return 'Cajón';
      case Equipment.roller:
        return 'Rodillo';
      case Equipment.abWheel:
        return 'Rueda';
      case Equipment.sandBag:
        return 'Búlgaro';
      case Equipment.bag:
        return 'Saco';
      case Equipment.ball:
        return 'Pelota';
      case Equipment.handgrip:
        return 'Handgrip';
      case Equipment.wallball:
        return 'Wallball';
    }
  }

  String get assetName {
    switch (this) {
      case Equipment.none:
        return 'assets/equipamientos/nada.png';
      case Equipment.bodyweight:
        return 'assets/equipamientos/peso_corporal.png';
      case Equipment.dumbbells:
        return 'assets/equipamientos/mancuerna.png';
      case Equipment.barbell:
        return 'assets/equipamientos/barra.png';
      case Equipment.kettlebell:
        return 'assets/equipamientos/kettlebell.png';
      case Equipment.machine:
        return 'assets/equipamientos/maquina.png';
      case Equipment.resistanceBand:
        return 'assets/equipamientos/banda_resistencia.png';
      case Equipment.rope:
        return 'assets/equipamientos/comba.png';
      case Equipment.plate:
        return 'assets/equipamientos/disco.png';
      case Equipment.battleRope:
        return 'assets/equipamientos/battleRope.png';
      case Equipment.plyometricBox:
        return 'assets/equipamientos/pliometrico.png';
      case Equipment.roller:
        return 'assets/equipamientos/rodillo.png';
      case Equipment.abWheel:
        return 'assets/equipamientos/rueda.png';
      case Equipment.sandBag:
        return 'assets/equipamientos/sandBag.png';
      case Equipment.bag:
        return 'assets/equipamientos/saco.png';
      case Equipment.ball:
        return 'assets/equipamientos/ball.png';
      case Equipment.handgrip:
        return 'assets/equipamientos/handgrip.png';
      case Equipment.wallball:
        return 'assets/equipamientos/wallball.png';
    }
  }
}

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyEx on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.beginner:
        return 'Principiante';
      case Difficulty.intermediate:
        return 'Intermedio';
      case Difficulty.advanced:
        return 'Avanzado';
    }
  }

  String get assetName {
    switch (this) {
      case Difficulty.beginner:
        return 'assets/dificultades/facil.png';
      case Difficulty.intermediate:
        return 'assets/dificultades/medio.png';
      case Difficulty.advanced:
        return 'assets/dificultades/dificil.png';
    }
  }
}

enum HistoryMode { day, week, month, year }

extension HistoryModeEx on HistoryMode {
  String get displayName {
    switch (this) {
      case HistoryMode.day:
        return 'Día';
      case HistoryMode.week:
        return 'Semana';
      case HistoryMode.month:
        return 'Mes';
      case HistoryMode.year:
        return 'Año';
    }
  }
}

enum ExerciseType { reps, time }

enum StatisticsOptions { workout, time, repetitions }

extension StatisticsOptionsEx on StatisticsOptions {
  String get displayName {
    switch (this) {
      case StatisticsOptions.workout:
        return 'Entrenamientos';
      case StatisticsOptions.time:
        return 'Tiempo';
      case StatisticsOptions.repetitions:
        return 'Repeticiones';
    }
  }
}

enum DayFormat { full, short, letter }
