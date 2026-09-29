import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/extensions.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class RutinesListPage extends StatefulWidget {
  static const String routeName = 'RutinesListPage';
  const RutinesListPage({super.key});

  @override
  State<RutinesListPage> createState() => _RutinesListPageState();
}

class _RutinesListPageState extends State<RutinesListPage> {
  @override
  Widget build(BuildContext context) {
    GymProvider gymProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Mis rutinas')),
        actions: [
          IconButton(
            onPressed: () {
              Preferences.groupedRutines = !Preferences.groupedRutines;
              setState(() {});
            },
            icon: Transform.flip(flipX: Preferences.groupedRutines, child: Icon(Utils.iconGrouped)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: gymProvider.rutines.isEmpty
                  ? Icon(Utils.iconReps, color: AppColors.divider, size: 150)
                  : _rutines(gymProvider.rutines),
            ),
            ButtonSaveWidget(
              onTap: () => Navigator.pushNamed(context, WorkoutPage.routeName),
              title: 'Nueva rutina',
              icon: Utils.iconAdd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rutines(List<Rutine> rutines) {
    List<Difficulty> difficulties = rutines.map((r) => r.difficulty).toSet().toList();
    if (Preferences.groupedRutines) {
      return Column(
        spacing: 20,
        children: [
          ...difficulties.map((d) {
            List<Rutine> list = rutines.where((r) => r.difficulty == d).toList()
              ..sort((a, b) => a.name.compareTo(b.name));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.displayName, style: TextStyle(fontSize: 25, color: AppColors.primaryDark)),
                10.h,
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RutineWidget(rutine: list[index]);
                  },
                ),
              ],
            );
          }),
        ],
      );
    } else {
      rutines.sort((a, b) => a.name.compareTo(b.name));
      return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: rutines.length,
        itemBuilder: (BuildContext context, int index) {
          return RutineWidget(rutine: rutines[index]);
        },
      );
    }
  }
}
