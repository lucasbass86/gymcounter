import 'package:flutter/material.dart';
import 'package:gymcounter/dialogs/dialogs.dart';
import 'package:gymcounter/helpers/helper.dart';
import 'package:gymcounter/helpers/utils.dart';
import 'package:gymcounter/models/_models.dart';
import 'package:gymcounter/pages/_pages.dart';
import 'package:gymcounter/preferences/preferences.dart';
import 'package:gymcounter/providers/_providers.dart';
import 'package:gymcounter/services/backup_service.dart';
import 'package:gymcounter/services/license_service.dart';
import 'package:gymcounter/widgets/_widget.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = Preferences.saveIndexHome ? Preferences.indexHome : 0;
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkData(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('GymCounter'),
        actions: [
          IconButton(
            tooltip: 'Configuración',
            onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
            icon: Icon(Utils.iconSettings),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) => setState(() {
          currentPage = value;
          Preferences.indexHome = currentPage;
        }),
        items: [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Utils.iconHome)),
          BottomNavigationBarItem(label: 'Historial', icon: Icon(Utils.iconPie)),
          BottomNavigationBarItem(label: 'Estadísticas', icon: Icon(Utils.iconStatistics)),
        ],
      ),
      drawer: MainDrawer(),
      body: _content(),
    );
  }

  Widget _content() {
    switch (currentPage) {
      case 0:
        return HomePage(
          onTap: () {
            setState(() {
              Preferences.indexTabHistory = 0;
              currentPage = 1;
            });
          },
        );
      case 1:
        return HistoryPage();
      case 2:
        return StatisticsPage();
      default:
        return HomePage();
    }
  }

  void _checkData(BuildContext context) async {
    final WeightProvider weightProvider = Provider.of<WeightProvider>(context, listen: false);
    if (weightProvider.weights.isNotEmpty) {
      final Measurement last = weightProvider.weights.first;
      final today = DateTime.now();
      final onlyDate = DateTime(today.year, today.month, today.day);
      if (last.date.add(Duration(days: Preferences.weightControl)).isBefore(onlyDate)) {
        final resp = await showAddWeight(context, title: 'Control de peso');
        if (resp != null) {
          if (resp[0] && context.mounted) {
            Helper.addWeight(context, resp[1], resp[2]);
          }
        }
      }
    }
    if (!_hasRun) {
      _hasRun = true;
      Future.delayed(const Duration(seconds: 1), () async {
        if (context.mounted) await LicenseService.checkLicense(context);
        if (context.mounted) await UpdateService.checkUpdates(context);
        if (context.mounted) await BackupService.checkBackUp(context);
      });
    }
  }
}
