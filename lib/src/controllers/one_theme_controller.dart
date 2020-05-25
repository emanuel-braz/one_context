import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneThemeChangerEvent {}

typedef OneAppBuilder = Widget Function<T>(BuildContext context, T data);

/// In order to change theme mode,
/// use `MaterialApp.themeMode: OneThemeController.initThemeMode(...)`
/// and configure `MaterialApp.theme: OneThemeController.initThemeData(...)`
/// and `MaterialApp.darkTheme: OneThemeController.initDarkThemeData(...)`
///
/// later, call `OneContext().oneTheme.changeMode(ThemeMode.dark);`
/// or `OneContext().oneTheme.changeThemeData(ThemeData(...));`
/// or `OneContext().oneTheme.changeDarkThemeData(ThemeData(...));`
///
/// Important: configure `MaterialApp.builder: OneContext().builder,`
/// and add `OneHotReload` as parent of MaterialApp.
class OneThemeController {
  OneThemeController() {
    loadThemeMode();
  }

  static const String _themeModeKey = 'themeModeKey';
  static const String _themeDataKey = 'themeDataKey';
  static const String _darkThemeDataKey = 'darkThemeDataKey';
  OneThemeController get oneTheme => this;
  BuildContext get context => OneContext().context;

  static ThemeMode _defaultMode = ThemeMode.light;

  static ThemeData _themeData;
  ThemeData get themeData => _themeData;
  static ThemeData initThemeData(ThemeData themeData) {
    if (themeData == null) throw FlutterError('themeData is required!');
    return _themeData ??= themeData;
  }

  void changeThemeData(ThemeData themeData, {BuildContext buildContext}) {
    _themeData = themeData;
    OneContext().oneNotifier.notify<OneThemeChangerEvent>(
        buildContext ?? OneContext().context, OneThemeChangerEvent());
  }

  /// Dark Theme
  static ThemeData _darkThemeData;
  ThemeData get darkThemeData => _darkThemeData;
  static ThemeData initDarkThemeData(ThemeData themeData) {
    if (themeData == null) throw FlutterError('themeData is required!');
    return _darkThemeData ??= themeData;
  }

  void changeDarkThemeData(ThemeData themeData, {BuildContext buildContext}) {
    _darkThemeData = themeData;
    OneContext().oneNotifier.notify<OneThemeChangerEvent>(
        buildContext ?? OneContext().context, OneThemeChangerEvent());
  }

  static ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode ?? _defaultMode;
  static Future<ThemeMode> getCurrentyMode() => _themeMode != null
      ? Future.value(_themeMode)
      : Future.value(_defaultMode);

  static ThemeMode initThemeMode(ThemeMode themeMode) {
    if (themeMode == null) throw FlutterError('ThemeMode is required!');
    return _themeMode ??= _defaultMode;
  }

  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isLight => _themeMode == ThemeMode.light;

  Future<void> loadThemeMode() async {
    final bool darkMode = await _isDarkModeFromStorage();
    _themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    OneContext().oneNotifier.notify<OneThemeChangerEvent>(
        OneContext().context, OneThemeChangerEvent());
  }

  Future<void> toggleMode([bool save = true]) async {
    if (isDark)
      changeMode(ThemeMode.light, save: save);
    else
      changeMode(ThemeMode.dark, save: save);
  }

  void changeMode(ThemeMode themeMode,
      {bool save = true, BuildContext buildContext}) {
    _themeMode = themeMode;
    OneContext().oneNotifier.notify<OneThemeChangerEvent>(
        buildContext ?? OneContext().context, OneThemeChangerEvent());
    if (save) {
      _saveMode(themeMode);
    }
  }

  Future<void> _saveMode(ThemeMode themeMode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeModeKey, themeMode == ThemeMode.dark);
    } catch (e) {}
  }

  Future<bool> _isDarkModeFromStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themeModeKey) ?? _defaultMode == ThemeMode.dark;
    } catch (e) {
      return _defaultMode == ThemeMode.dark;
    }
  }

  static void clear() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(_themeModeKey);
      prefs.remove(_themeDataKey);
      prefs.remove(_darkThemeDataKey);
    } catch (e) {}
  }
}
