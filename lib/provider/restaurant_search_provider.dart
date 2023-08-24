import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_search_model.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/utils/string_helper.dart';

class RestaurantsSearchListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsSearchListProvider({required this.apiService}) {
    _state = ResultState.notStarted;
  }

  late WrapRestaurants _wrapRestaurants;
  late ResultState _state;
  String _message = '';

  WrapRestaurants get wrapRestaurants => _wrapRestaurants;

  ResultState get state => _state;

  String get message => _message;

  void fetchSearchListRestaurant(String restaurantName) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final wrapRestaurants =
          await apiService.getRestaurantsSearchList(restaurantName);
      if (wrapRestaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = StringHelper.emptyData;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _wrapRestaurants = wrapRestaurants;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      _message = StringHelper.noInternetConnection;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      _message = StringHelper.failedToLoadData;
    }
  }
}
