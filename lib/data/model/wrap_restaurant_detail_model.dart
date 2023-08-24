import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_detail_model.dart';

class WrapRestaurant {
  final bool error;
  final String message;
  final Restaurant restaurant;

  WrapRestaurant({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory WrapRestaurant.fromRawJson(String str) =>
      WrapRestaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WrapRestaurant.fromJson(Map<String, dynamic> json) {
    return WrapRestaurant(
      error: json["error"],
      message: json["message"],
      restaurant: Restaurant.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "restaurant": restaurant.toJson(),
    };
  }
}
