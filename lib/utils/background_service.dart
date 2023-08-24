import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate_restaurant_recommendation';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  /// show random restaurant recommendations, from notification
  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var wrapRestaurants = await ApiService().getRestaurantsList();

    final random = Random();
    final index = random.nextInt(wrapRestaurants.restaurants.length - 1);
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, wrapRestaurants.restaurants[index]);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}