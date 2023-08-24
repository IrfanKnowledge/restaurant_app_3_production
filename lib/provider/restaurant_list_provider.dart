import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_list_model.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/utils/string_helper.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    _fetchListRestaurants();
  }

  late WrapRestaurants _wrapRestaurants;
  late ResultState _state;
  String _message = '';

  WrapRestaurants get wrapRestaurants => _wrapRestaurants;

  ResultState get state => _state;

  String get message => _message;

  Future<dynamic> _fetchListRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final wrapRestaurants = await apiService.getRestaurantsList();
      if (wrapRestaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = StringHelper.emptyData;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _wrapRestaurants = wrapRestaurants;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = StringHelper.noInternetConnection;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = StringHelper.failedToLoadData;
    }
  }
}
