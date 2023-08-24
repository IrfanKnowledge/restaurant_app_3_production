import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/wrap_restaurant_list_model.dart';

void main() {
  group('Restaurant List Page Test', () {
    // arrange
    late String response;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      response =
          await rootBundle.loadString('assets/restaurant_list_page.json');
    });

    test('must contain message = success', () async {
      // arrange
      const message = 'success';

      // act
      final wrapRestaurants = WrapRestaurants.fromRawJson(response);
      final wrapRestMessage = wrapRestaurants.message;

      // assert
      expect(wrapRestMessage, message);
    });

    test('restaurant is not empty', () async {
      // arrange
      const restIsNotEmpty = true;

      // act
      final wrapRestaurants = WrapRestaurants.fromRawJson(response);
      final restaurant = wrapRestaurants.restaurants;

      // assert
      expect(restaurant.isNotEmpty, restIsNotEmpty);
    });

    test('must contain specified restaurant id', () async {
      // arrange
      const restId = 'rqdv5juczeskfw1e867';

      // act
      final wrapRestaurants = WrapRestaurants.fromRawJson(response);
      final restaurantId = wrapRestaurants.restaurants[0].id;

      // assert
      expect(restaurantId, restId);
    });
  });
}
