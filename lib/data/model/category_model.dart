import 'dart:convert';

class Category {
  final String name;

  Category({
    required this.name,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}
