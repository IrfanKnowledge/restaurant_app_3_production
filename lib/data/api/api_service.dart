import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/wrap_restaurant_detail_model.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_list_model.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_search_model.dart'
    as restaurant_search;

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _endPointGetList = 'list';
  static const String _endPointGet = 'detail/';
  static const String _endPointGetSearchList = 'search';

  Future<WrapRestaurants> getRestaurantsList() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endPointGetList'));
    if (response.statusCode == 200) {
      final wrapRestaurants = WrapRestaurants.fromRawJson(response.body);
      return wrapRestaurants;
    } else {
      throw _exception('RestaurantsList');
    }
  }

  Future<WrapRestaurant> getRestaurant(String path) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endPointGet$path'));
    if (response.statusCode == 200) {
      final wrapRestaurant = WrapRestaurant.fromRawJson(response.body);
      return wrapRestaurant;
    } else {
      throw _exception('RestaurantDetail');
    }
  }

  Future<restaurant_search.WrapRestaurants> getRestaurantsSearchList(
      String restaurantName) async {
    final searchListQueryParameters = {
      'q': restaurantName,
    };
    final response = await http.get(
        Uri.parse('$_baseUrl$_endPointGetSearchList' '?')
            .replace(queryParameters: searchListQueryParameters));
    if (response.statusCode == 200) {
      final wrapRestaurants =
          restaurant_search.WrapRestaurants.fromRawJson(response.body);
      return wrapRestaurants;
    } else {
      throw _exception('RestaurantsSearchList');
    }
  }

  Exception _exception(String processName) =>
      Exception('Failed to load $processName');
}
