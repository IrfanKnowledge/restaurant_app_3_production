import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> setScheduledRestaurantRecommendation(bool value) async {
    const id = 1;
    _isScheduled = value;

    if (_isScheduled) {
      const hours = 24;

      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: hours),
        id,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
      // return await AndroidAlarmManager.oneShot(
      //   Duration(seconds: 5),
      //   id,
      //   BackgroundService.callback,
      //   exact: true,
      //   wakeup: true,
      // );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(id);
    }
  }
}
