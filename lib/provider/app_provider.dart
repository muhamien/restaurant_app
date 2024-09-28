import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  static const String scheduleNotificationPref = 'scheduleNotification';
  bool _isNotificationScheduled = false;

  bool get isNotificationScheduled => _isNotificationScheduled;

  AppProvider() {
    _loadSettingPrefs();
  }

  void _loadSettingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationScheduled = prefs.getBool(scheduleNotificationPref) ?? false;
    notifyListeners();
  }

  void setNotificationSchedule(bool value) async {
    _isNotificationScheduled = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(scheduleNotificationPref, _isNotificationScheduled);
    notifyListeners();
  }
}
