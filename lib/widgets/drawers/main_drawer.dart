import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/theme/appcolors.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppColors.card),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png', width: 50, height: 50),
                    Text(
                      'GymCounter',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconDumbbell),
                    title: Text('Ejercicios'),
                    onTap: () {
                      Navigator.pushNamed(context, ExercisesListPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconFire),
                    title: Text('Workouts'),
                    onTap: () {
                      Navigator.pushNamed(context, WorkoutsListPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconReps),
                    title: Text('Rutinas'),
                    onTap: () {
                      Navigator.pushNamed(context, RutinesListPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconPlay),
                    title: Text('Play Rutine'),
                    onTap: () async {
                      final Rutine? rutine = await modalPlayRutine(context);
                      if (rutine != null && context.mounted) {
                        Navigator.pushNamed(context, PlayRutinePage.routeName, arguments: rutine);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconTarget),
                    title: Text('Objetivos'),
                    onTap: () {
                      Navigator.pushNamed(context, ListTargetsPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconWeight),
                    title: Text('Control de peso'),
                    onTap: () {
                      Navigator.pushNamed(context, WeightPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
