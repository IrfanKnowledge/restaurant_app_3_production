import 'package:flutter/material.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart'
    as restaurant_detail;
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/utils/string_helper.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper});

  late ResultState _state;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Restaurant> _restaurantBookmarks = [];

  List<Restaurant> get restaurantBookmarks => _restaurantBookmarks;

  void getRestaurantBookmarks() async {
    _state = ResultState.loading;
    _restaurantBookmarks = await databaseHelper.getRestaurantBookmarks();
    if (_restaurantBookmarks.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = StringHelper.emptyData;
    }
    notifyListeners();
  }

  void addRestaurantBookmark(restaurant_detail.Restaurant restaurant) async {
    try {
      await databaseHelper.insertRestaurantBookmark(restaurant);
      getRestaurantBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isRestaurantBookmarked(String id) async {
    final bookmarkedRestaurant =
        await databaseHelper.getRestaurantBookmarkById(id);
    return bookmarkedRestaurant.isNotEmpty;
  }

  void removeRestaurantBookmark(String id) async {
    try {
      await databaseHelper.removeBookmark(id);
      getRestaurantBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void refreshList(String result) {
    getRestaurantBookmarks();
  }
}
