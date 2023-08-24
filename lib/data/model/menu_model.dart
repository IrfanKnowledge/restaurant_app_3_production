import 'dart:convert';

import 'package:restaurant_app/data/model/category_model.dart';

class Menu {
  final List<Category> foods;
  final List<Category> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });

  factory Menu.fromRawJson(String str) => Menu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods:
          List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
      drinks:
          List<Category>.from(json["drinks"].map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
      "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
    };
  }
}
