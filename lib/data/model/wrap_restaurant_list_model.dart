import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_list_model.dart';

class WrapRestaurants {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  WrapRestaurants({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory WrapRestaurants.fromRawJson(String str) =>
      WrapRestaurants.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WrapRestaurants.fromJson(Map<String, dynamic> json) {
    return WrapRestaurants(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "count": count,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}
