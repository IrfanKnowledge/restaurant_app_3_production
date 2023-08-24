import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  bool _isDailyReminderActive = false;

  bool get isDailyReminderActive => _isDailyReminderActive;

  /// always check and get the current data from SharedPreferences when do instantiation
  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyReminderPreferences();
  }

  void _getDailyReminderPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void setDailyReminder(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminderPreferences();
  }
}
