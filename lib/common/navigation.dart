import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentReplacement(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  static intentWithoutData(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static intentWithData(String routeName, Object arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static back() => navigatorKey.currentState?.pop();
}
