import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/widgets/card_list_tile_restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/failed_load_restaurant.dart';

// ignore: must_be_immutable
class RestaurantBookmarkListPage extends StatefulWidget {
  static const routeName = '/restaurant_bookmark_list_page';

  const RestaurantBookmarkListPage({super.key});

  @override
  State<RestaurantBookmarkListPage> createState() =>
      _RestaurantBookmarkListPageState();
}

class _RestaurantBookmarkListPageState
    extends State<RestaurantBookmarkListPage> {
  int _gridCrossAxisCount = 1;

  @override
  Widget build(BuildContext context) {
    return _buildLayoutBuilder();
  }

  LayoutBuilder _buildLayoutBuilder() {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth <= 600) {
        _gridCrossAxisCount = 1;
      } else if (constraints.maxWidth <= 900) {
        _gridCrossAxisCount = 2;
      } else if (constraints.maxWidth <= 1200) {
        _gridCrossAxisCount = 3;
      } else if (constraints.maxWidth <= 1500) {
        _gridCrossAxisCount = 4;
      } else {
        _gridCrossAxisCount = 5;
      }
      return _buildScaffold();
    });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Restaurants Page'),
        elevation: 4,
      ),
      body: _buildChangeNotifierProvider(),
    );
  }

  Widget _buildChangeNotifierProvider() {
    return ChangeNotifierProvider<DatabaseProvider>(
      create: (context) {
        DatabaseProvider databaseProvider =
            DatabaseProvider(databaseHelper: DatabaseHelper());
        databaseProvider.getRestaurantBookmarks();
        return databaseProvider;
      },
      child: _buildConsumerBookmarkedRestaurantsListProvider(),
    );
  }

  Widget _buildConsumerBookmarkedRestaurantsListProvider() {
    return Consumer<DatabaseProvider>(
      builder: (context, databaseProvider, _) {
        if (databaseProvider.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (databaseProvider.state == ResultState.hasData) {
          final restaurants = databaseProvider.restaurantBookmarks;
          return _buildRestaurantsResult(
            databaseProvider: databaseProvider,
            restaurants: restaurants,
          );
        } else if (databaseProvider.state == ResultState.noData) {
          return FailedLoadRestaurant(message: databaseProvider.message);
        } else if (databaseProvider.state == ResultState.error) {
          return FailedLoadRestaurant(message: databaseProvider.message);
        } else {
          return FailedLoadRestaurant(message: databaseProvider.message);
        }
      },
    );
  }

  Widget _buildRestaurantsResult({
    required DatabaseProvider databaseProvider,
    required List<Restaurant> restaurants,
  }) {
    if (_gridCrossAxisCount == 1) {
      return _buildListView(
        databaseProvider: databaseProvider,
        restaurants: restaurants,
      );
    } else {
      return _buildGridView(
        databaseProvider: databaseProvider,
        restaurants: restaurants,
      );
    }
  }

  ListView _buildListView({
    required DatabaseProvider databaseProvider,
    required List<Restaurant> restaurants,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return CardListTileRestaurant(
          restaurants[index],
          () {
            Navigator.pushNamed(
              context,
              RestaurantDetailPage.routeName,
              arguments: restaurants[index].id,
            ).then((_) => databaseProvider.getRestaurantBookmarks());
            // print('result: $result');
          },
        );
      },
    );
  }

  GridView _buildGridView({
    required DatabaseProvider databaseProvider,
    required List<Restaurant> restaurants,
  }) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      crossAxisCount: _gridCrossAxisCount,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: restaurants.map(
        (restaurant) {
          return CardRestaurant(
            restaurant,
            () {
              Navigator.pushNamed(
                context,
                RestaurantDetailPage.routeName,
                arguments: restaurant.id,
              ).then((_) => databaseProvider.getRestaurantBookmarks());
            },
          );
        },
      ).toList(),
    );
  }
}
