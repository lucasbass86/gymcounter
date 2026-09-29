import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymcounter/hive/boxes.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/routes/routes.dart';
import 'package:gymcounter/theme/theme.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Preferences.init();

  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);

  await Hive.openBox(Boxes.boxNameExercises);
  await Hive.openBox(Boxes.boxNameWeight);
  await Hive.openBox(Boxes.boxNameWorkouts);
  await Hive.openBox(Boxes.boxNameCurrentWorkout);
  await Hive.openBox(Boxes.boxNameRutines);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GymProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => WeightProvider(), lazy: true),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GymCounter',
      routes: routes,
      initialRoute: MainPage.routeName,
      theme: appTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es')],
    );
  }
}
