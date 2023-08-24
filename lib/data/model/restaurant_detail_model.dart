import 'dart:convert';

import 'package:restaurant_app/data/model/category_model.dart';
import 'package:restaurant_app/data/model/customer_review_model.dart';
import 'package:restaurant_app/data/model/menu_model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory Restaurant.fromRawJson(String str) =>
      Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x))),
      menus: Menu.fromJson(json["menus"]),
      rating: json["rating"]?.toDouble(),
      customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "city": city,
      "address": address,
      "pictureId": pictureId,
      "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      "menus": menus.toJson(),
      "rating": rating,
      "customerReviews":
          List<dynamic>.from(customerReviews.map((x) => x.toJson())),
    };
  }
}
