import 'package:flutter/material.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/theme/appcolors.dart';
import 'package:gymcounter/widgets/_widget.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onTap;
  const HomePage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    GymProvider gymProvider = Provider.of<GymProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          WorkoutPage.routeName,
          arguments: gymProvider.currentWorkout ?? true,
        ),
        child: Icon(Utils.iconDumbbell, color: AppColors.surface),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ResumeWidget(gymProvider: gymProvider, onTap: () => onTap?.call()),
                  RecentRutineWidget(gymProvider: gymProvider),
                  RecentExercisesListWidget(gymProvider: gymProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
