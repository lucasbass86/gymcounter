import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/modal_bottoms.dart';
import 'package:gymcounter/helpers/enums.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';

class RutineWidget extends StatelessWidget {
  final Rutine rutine;
  const RutineWidget({super.key, required this.rutine});

  @override
  Widget build(BuildContext context) {
    final GymProvider gymProvider = Provider.of<GymProvider>(context, listen: false);
    int workouts = gymProvider.workouts.where((w) => w.idRutine == rutine.id).length;
    return GestureDetector(
      onTap: () => modalRutine(context, rutine),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    Image.asset(rutine.difficulty.assetName, width: 20, height: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Text(rutine.name, style: TextStyle(color: Colors.white)),
                          ),
                          Text(
                            rutine.exercisesSet.length == 1
                                ? '1 ejercicio'
                                : '${rutine.exercisesSet.length} ejercicios',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(workouts.toString(), style: TextStyle(color: Colors.white)),
                      Text(workouts == 1 ? 'workout' : 'workouts'),
                    ],
                  ),
                  _menu(gymProvider),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu(GymProvider gymProvider) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      constraints: BoxConstraints(maxWidth: 70),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: IconButton(
              tooltip: 'Comenzar',
              onPressed: () async {
                await Navigator.pushNamed(context, PlayRutinePage.routeName, arguments: rutine);
                if (context.mounted) Navigator.pop(context);
              },
              icon: Icon(Utils.iconPlay),
            ),
          ),
          PopupMenuItem(
            child: IconButton(
              tooltip: 'Detalle',
              onPressed: () async {
                await Navigator.pushNamed(context, RutineDetailPage.routeName, arguments: rutine);
                if (context.mounted) Navigator.pop(context);
              },
              icon: Icon(Utils.iconStatistics),
            ),
          ),
        ];
      },
    );
  }
}
