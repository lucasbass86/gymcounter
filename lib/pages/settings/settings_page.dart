import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/hive/boxes.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/services/backup_service.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _StatiHistorytate();
}

class _StatiHistorytate extends State<SettingsPage> {
  late GymProvider gymProvider;
  late WeightProvider weightProvider;
  Duration restBetweenReps = Duration(
    minutes: Preferences.restMinutes,
    seconds: Preferences.restSeconds,
  );
  TextEditingController controllerReps = TextEditingController(
    text: Preferences.respForDay.toString(),
  );
  int weightControl = Preferences.weightControl;
  int daysOfRecentExercises = Preferences.daysOfRecentExercises;
  bool saveIndexHome = Preferences.saveIndexHome;
  bool groupRecentExercises = Preferences.groupRecentExercises;
  bool activeScreen = Preferences.activeScreen;
  late TextEditingController emailController;
  int backupDays = Preferences.backupDays;
  int recordsForGraphics = Preferences.recordsForGraphics;

  @override
  Widget build(BuildContext context) {
    gymProvider = Provider.of<GymProvider>(context, listen: false);
    weightProvider = Provider.of<WeightProvider>(context, listen: false);
    emailController = TextEditingController(text: Preferences.email);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Configuración')),
        actions: [
          GestureDetector(
            onTap: () => _savePreferences(),
            child: Row(
              spacing: 5,
              children: [
                Icon(Utils.iconCheck, color: AppColors.success),
                Text('Guardar', style: TextStyle(color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _goals(),
              20.h,
              _defaults(),
              20.h,
              _weightControl(),
              20.h,
              _recentExercises(),
              20.h,
              _homeScreen(),
              20.h,
              _playRutine(),
              20.h,
              _recordsInGraphs(),
              20.h,
              FutureBuilder(
                future: Utils.checkConnection(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool resp = snapshot.data as bool;
                    if (resp) {
                      return _backUp(context);
                    } else {
                      return _noConnection();
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              20.h,
              _appInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Licencia: ${Preferences.license}',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Divider(color: AppColors.divider),
                    FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          PackageInfo packageInfo = snapshot.data as PackageInfo;
                          return Text(
                            'Version: ${packageInfo.version}',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          );
                        } else {
                          return Text('');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _noConnection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.wifi_off_rounded), Text('No hay conexión')],
    );
  }

  Widget _backUp(BuildContext context) {
    _checkPassword(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Copias de seguridad', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email para las copias', style: TextStyle(color: Colors.white, fontSize: 17)),
                20.h,
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: 'email', counterText: ''),
                        ),
                      ),
                    ),
                    if (Preferences.email.isEmpty)
                      IconButton(
                        onPressed: () async {
                          if (emailController.text.isEmpty) {
                            _showSnackBar('Introduce el email');
                          } else {
                            String pass = '';
                            if (Preferences.passBackUp.isEmpty) {
                              pass = await _askPassword(context);
                              if (pass.isEmpty) return;
                            }
                            _showSnackBar('Email guardado');
                            Preferences.email = emailController.text;
                            Preferences.passBackUp = pass;
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.save),
                      ),
                    if (Preferences.email.isNotEmpty)
                      IconButton(
                        onPressed: () async {
                          final resp = await showMessage(
                            context: context,
                            message: '¿Quitar el email?',
                            cancel: true,
                          );
                          if (resp && context.mounted) {
                            final confirm = await showSlideToUnlock(
                              context,
                              backColor: AppColors.primary,
                              slideColor: AppColors.card,
                            );
                            if (confirm) {
                              Preferences.email = '';
                              Preferences.backUp = '';
                              Preferences.passBackUp = '';
                              setState(() {});
                            }
                          }
                        },
                        icon: Icon(Icons.emergency_rounded, semanticLabel: 'Eliminar el email'),
                      ),
                  ],
                ),
                if (Preferences.email.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _uploadDataToInternet(context),
                          _downloadFromInternet(context),
                          IconButton(
                            onPressed: () async {
                              await showMessage(
                                context: context,
                                message: '¿Borrar todos los datos de la copia?',
                                cancel: true,
                              ).then((value) {
                                if (value && context.mounted) {
                                  showSlideToUnlock(
                                    context,
                                    backColor: AppColors.primary,
                                    slideColor: AppColors.card,
                                  ).then((unlock) {
                                    if (unlock) {
                                      BackupService.deleteBackUp(emailController.text).then((_) {
                                        Preferences.email = '';
                                        Preferences.backUp = '';
                                        Preferences.passBackUp = '';
                                        setState(() {});
                                        _showSnackBar('Datos borrados');
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Última copia: ${Preferences.backUp.isEmpty ? '--/--/----' : Utils.dateEnglishToSpanish(DateTime.parse(Preferences.backUp))}',
                      ),
                      Divider(color: AppColors.divider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Aviso días copia'),
                          BasicContainerWidget(
                            child: DropdownButton(
                              value: backupDays,
                              borderRadius: BorderRadius.circular(20),
                              underline: Container(),
                              iconEnabledColor: AppColors.subtitle,
                              items: [10, 20, 30, 40, 50, 60]
                                  .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
                                  .toList(),
                              onChanged: (value) => setState(() => backupDays = value!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _checkPassword(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (Preferences.passBackUp.isEmpty && context.mounted) {
        Preferences.passBackUp = await _askPassword(context);
      }
    });
  }

  Future<String> _askPassword(BuildContext context) async {
    final pass = await password(
      context,
      subtitle: 'Para poder reestablecer las copias de seguridad.',
    );
    if (!pass[0]) return '';
    if (!context.mounted) return '';
    final pass2 = await password(context, title: 'Repite password');
    if (!context.mounted || pass == null || pass.isEmpty || !pass[0]) {
      return '';
    }
    if (pass[1] != pass2[1]) {
      _showSnackBar('Las contraseñas no coinciden', isGood: false);
      return '';
    }
    return pass[1];
  }

  void _showSnackBar(String message, {bool isGood = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar(message, isBad: !isGood));
  }

  Widget _uploadDataToInternet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final res = await showSlideToUnlock(
          context,
          backColor: AppColors.primary,
          slideColor: AppColors.card,
        );
        if (res) {
          User user = User(
            email: emailController.text,
            password: Preferences.passBackUp,
            exercises: gymProvider.exercises,
            measurements: weightProvider.weights,
            rutines: gymProvider.rutines,
            workouts: gymProvider.workouts,
            targets: gymProvider.targets,
          );
          await BackupService.addBackUp(user);
          _showSnackBar('Copia subida', isGood: true);
          Preferences.backUp = DateTime.now().toString();
          setState(() {});
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [Text('Subir datos'), const SizedBox(height: 5), Icon(Icons.backup_sharp)],
        ),
      ),
    );
  }

  Widget _downloadFromInternet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (emailController.text.isNotEmpty) {
          User? user = await BackupService.getBackUp(emailController.text);
          if (!context.mounted) return;
          final passResult = await password(context);
          if (passResult[1] != Preferences.passBackUp && passResult[1] != user!.password) {
            _showSnackBar('Contraseña incorrecta', isGood: false);
            return;
          }

          if (context.mounted) {
            final confirmed = await showMessage(
              context: context,
              message: 'Si hay datos, estos se sustituirán. ¿Sustituir?',
              cancel: true,
            );
            if (confirmed && context.mounted) {
              final unlock = await showSlideToUnlock(
                context,
                backColor: AppColors.primary,
                slideColor: AppColors.card,
              );
              if (unlock && context.mounted) {
                _setData(context, user!);
              }
            } else {
              _showSnackBar('Proceso omitido');
            }
          } else {
            _showSnackBar('Email no encontrado', isGood: false);
          }
        } else {
          _showSnackBar('Introduce el correo', isGood: false);
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [Text('Cargar datos'), const SizedBox(height: 5), Icon(Icons.restore)],
        ),
      ),
    );
  }

  void _setData(BuildContext context, User user) async {
    gymProvider.exercises = user.exercises;
    gymProvider.rutines = user.rutines;
    gymProvider.workouts = user.workouts;
    gymProvider.targets = user.targets;
    weightProvider.weights = user.measurements;

    await Boxes.exercises.deleteAll(Boxes.exercises.keys);
    await Boxes.rutines.deleteAll(Boxes.rutines.keys);
    await Boxes.workouts.deleteAll(Boxes.workouts.keys);
    await Boxes.targets.deleteAll(Boxes.targets.keys);
    await Boxes.weights.deleteAll(Boxes.weights.keys);

    for (Exercise t in user.exercises) {
      await Boxes.exercises.put(t.id, t.toJson());
    }
    for (Rutine m in user.rutines) {
      await Boxes.rutines.put(m.id, m.toJson());
    }
    for (Workout p in user.workouts) {
      await Boxes.workouts.put(p.id, p.toJson());
    }
    for (Target t in user.targets) {
      await Boxes.targets.put(t.id, t.toJson());
    }
    for (Measurement pm in user.measurements) {
      await Boxes.weights.put(pm.id, pm.toJson());
    }

    _showSnackBar('Datos cargados', isGood: true);
    gymProvider.notify();
  }

  Widget _recordsInGraphs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Registros en graficos', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Últimos', style: TextStyle(color: Colors.white, fontSize: 17)),
                BasicContainerWidget(
                  width: 120,
                  child: DropdownButton(
                    value: recordsForGraphics,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(20),
                    items: Utils.recordsForGraphics
                        .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
                        .toList(),
                    onChanged: (value) => setState(() => recordsForGraphics = value!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _playRutine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pantalla Rutina', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pantalla activa', style: TextStyle(color: Colors.white, fontSize: 17)),
                    Switch(
                      value: activeScreen,
                      onChanged: (value) => setState(() => activeScreen = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _homeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pantalla Inicio', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Guardar posición', style: TextStyle(color: Colors.white, fontSize: 17)),
                    Switch(
                      value: saveIndexHome,
                      onChanged: (value) => setState(() => saveIndexHome = value),
                    ),
                  ],
                ),
                Divider(color: AppColors.divider),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agrupar ejercicios recientes',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Switch(
                      value: groupRecentExercises,
                      onChanged: (value) => setState(() => groupRecentExercises = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentExercises() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ejercicios recientes', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Días', style: TextStyle(color: Colors.white, fontSize: 17)),
                BasicContainerWidget(
                  child: DropdownButton(
                    value: daysOfRecentExercises,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(20),
                    items: Utils.daysForRecentExercises
                        .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
                        .toList(),
                    onChanged: (value) => setState(() => daysOfRecentExercises = value!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _weightControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Control de peso', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Días para el recordatorio',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                BasicContainerWidget(
                  child: DropdownButton(
                    value: weightControl,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(20),
                    items: Utils.weightDays
                        .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
                        .toList(),
                    onChanged: (value) => setState(() => weightControl = value!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Valores predeterminados', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Descanso repeticiones', style: TextStyle(color: Colors.white, fontSize: 17)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    final resp = await showPacePicker(
                      context: context,
                      initialPace: restBetweenReps,
                    );
                    if (resp != null) {
                      restBetweenReps = resp;
                      setState(() {});
                    }
                  },
                  child: BasicContainerWidget(
                    child: Text(
                      Utils.durationToString(restBetweenReps),
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _goals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Objetivos diarios', style: TextStyle(fontSize: 20, color: AppColors.primary)),
        10.h,
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Repeticiones', style: TextStyle(color: Colors.white, fontSize: 17)),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: controllerReps,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '0', counterText: ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _savePreferences() {
    //OBJETIVOS DIARIOS
    Preferences.respForDay = int.parse(controllerReps.text);
    //VALORES PREDETERMINADOS
    Preferences.restMinutes = restBetweenReps.inMinutes;
    Preferences.restSeconds = Utils.secondsDuration(restBetweenReps);
    //CONTROL DE PESO
    Preferences.weightControl = weightControl;
    //EJERCICIOS RECIENTES
    gymProvider.daysOfRecentExercises = daysOfRecentExercises;
    //PANTALLA INICIO
    Preferences.saveIndexHome = saveIndexHome;
    Preferences.groupRecentExercises = groupRecentExercises;
    //PANTALLA RUTINA
    Preferences.activeScreen = activeScreen;
    //REGISTROS POR GRAFICOS:
    Preferences.recordsForGraphics = recordsForGraphics;
    //COPIAS DE SEGURIDAD
    Preferences.backupDays = backupDays;
    //CERRAR
    ScaffoldMessenger.of(context).showSnackBar(Utils.snackBar('Preferencias guardadas'));
    Navigator.pop(context);
  }
}

Future<dynamic> password(
  BuildContext context, {
  String title = 'Introduce el password',
  String? subtitle,
}) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(subtitle, style: TextStyle(fontSize: 17)),
                ],
              ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return TextField(
              onChanged: (value) {},
              controller: edPassword,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password', fillColor: AppColors.background),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop([false]),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop([true, edPassword.text]),
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
