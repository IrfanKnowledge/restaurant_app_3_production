import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_list_model.dart';

class WrapRestaurants {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  WrapRestaurants({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory WrapRestaurants.fromRawJson(String str) =>
      WrapRestaurants.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WrapRestaurants.fromJson(Map<String, dynamic> json) {
    return WrapRestaurants(
      error: json["error"],
      founded: json["founded"],
      restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "founded": founded,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}
