import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static double _height = 1.75;
  static double get height => _prefs.getDouble('height') ?? _height;
  static set height(double value) {
    _height = value;
    _prefs.setDouble('height', value);
  }

  static int _repsForDay = 0;
  static int get respForDay => _prefs.getInt('respForDay') ?? _repsForDay;
  static set respForDay(int value) {
    _repsForDay = value;
    _prefs.setInt('respForDay', value);
  }

  static int _hoursForDay = 0;
  static int get hoursForDay => _prefs.getInt('hoursForDay') ?? _hoursForDay;
  static set hoursForDay(int value) {
    _hoursForDay = value;
    _prefs.setInt('hoursForDay', value);
  }

  static int _minutesForDay = 30;
  static int get minutesForDay => _prefs.getInt('minutesForDay') ?? _minutesForDay;
  static set minutesForDay(int value) {
    _minutesForDay = value;
    _prefs.setInt('minutesForDay', value);
  }

  static int _restMinutes = 0;
  static int get restMinutes => _prefs.getInt('restMinutes') ?? _restMinutes;
  static set restMinutes(int value) {
    _restMinutes = value;
    _prefs.setInt('restMinutes', value);
  }

  static int _restSeconds = 0;
  static int get restSeconds => _prefs.getInt('restSeconds') ?? _restSeconds;
  static set restSeconds(int value) {
    _restSeconds = value;
    _prefs.setInt('restSeconds', value);
  }

  static int _weightControl = 1;
  static int get weightControl => _prefs.getInt('weightControl') ?? _weightControl;
  static set weightControl(int value) {
    _weightControl = value;
    _prefs.setInt('weightControl', value);
  }

  static int _indexTabExerciseHistory = 1;
  static int get indexTabExerciseHistory =>
      _prefs.getInt('indexTabExerciseHistory') ?? _indexTabExerciseHistory;
  static set indexTabExerciseHistory(int value) {
    _indexTabExerciseHistory = value;
    _prefs.setInt('indexTabExerciseHistory', value);
  }

  static int _indexTabHistory = 0;
  static int get indexTabHistory => _prefs.getInt('indexTabHistory') ?? _indexTabHistory;
  static set indexTabHistory(int value) {
    _indexTabHistory = value;
    _prefs.setInt('indexTabHistory', value);
  }

  static int _indexTabStatistics = 1;
  static int get indexTabStatistics => _prefs.getInt('indexTabStatistics') ?? _indexTabStatistics;
  static set indexTabStatistics(int value) {
    _indexTabStatistics = value;
    _prefs.setInt('indexTabStatistics', value);
  }

  static int _indexTabWorkouts = 1;
  static int get indexTabWorkouts => _prefs.getInt('indexTabWorkouts') ?? _indexTabWorkouts;
  static set indexTabWorkouts(int value) {
    _indexTabWorkouts = value;
    _prefs.setInt('indexTabWorkouts', value);
  }

  static int _daysOfRecentExercises = 3;
  static int get daysOfRecentExercises =>
      _prefs.getInt('daysOfRecentExercises') ?? _daysOfRecentExercises;
  static set daysOfRecentExercises(int value) {
    _daysOfRecentExercises = value;
    _prefs.setInt('daysOfRecentExercises', value);
  }

  static int _indexHome = 0;
  static int get indexHome => _prefs.getInt('indexHome') ?? _indexHome;
  static set indexHome(int value) {
    _indexHome = value;
    _prefs.setInt('indexHome', value);
  }

  static bool _saveIndexHome = false;
  static bool get saveIndexHome => _prefs.getBool('saveIndexHome') ?? _saveIndexHome;
  static set saveIndexHome(bool value) {
    _saveIndexHome = value;
    _prefs.setBool('saveIndexHome', value);
  }

  static bool _groupRecentExercises = false;
  static bool get groupRecentExercises =>
      _prefs.getBool('groupRecentExercises') ?? _groupRecentExercises;
  static set groupRecentExercises(bool value) {
    _groupRecentExercises = value;
    _prefs.setBool('groupRecentExercises', value);
  }

  static bool _groupedRutines = false;
  static bool get groupedRutines => _prefs.getBool('groupedRutines') ?? _groupedRutines;
  static set groupedRutines(bool value) {
    _groupedRutines = value;
    _prefs.setBool('groupedRutines', value);
  }

  static bool _activeScreen = true;
  static bool get activeScreen => _prefs.getBool('activeScreen') ?? _activeScreen;
  static set activeScreen(bool value) {
    _activeScreen = value;
    _prefs.setBool('activeScreen', value);
  }

  static String _backUp = '';
  static String get backUp => _prefs.getString('backUp') ?? _backUp;
  static set backUp(String value) {
    _backUp = value;
    _prefs.setString('backUp', _backUp);
  }

  static int _backupDays = 10;
  static int get backupDays => _prefs.getInt('backupDays') ?? _backupDays;
  static set backupDays(int value) {
    _backupDays = value;
    _prefs.setInt('backupDays', value);
  }

  static String _license = '';
  static String get license => _prefs.getString('license') ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString('license', value);
  }

  static String _email = '';
  static String get email => _prefs.getString('email') ?? _email;
  static set email(String value) {
    _email = value;
    _prefs.setString('email', value);
  }

  static String _passBackUp = '';
  static String get passBackUp => _prefs.getString('passBackUp') ?? _passBackUp;
  static set passBackUp(String value) {
    _passBackUp = value;
    _prefs.setString('passBackUp', value);
  }
}
