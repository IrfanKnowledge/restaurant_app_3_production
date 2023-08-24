import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_detail_model.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/utils/string_helper.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurantId}) {
    _fetchDetailRestaurant();
  }

  late WrapRestaurant _wrapRestaurant;
  late ResultState _state;
  String _message = '';

  WrapRestaurant get wrapRestaurant => _wrapRestaurant;

  ResultState get state => _state;

  String get message => _message;

  void _fetchDetailRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final wrapRestaurant = await apiService.getRestaurant(restaurantId);
      if (wrapRestaurant.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = StringHelper.emptyData;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _wrapRestaurant = wrapRestaurant;
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
