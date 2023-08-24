import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/widgets/card_list_tile_restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/failed_load_restaurant.dart';

class RestaurantSearchListPage extends StatefulWidget {
  static const routeName = '/restaurant_search_list_page';

  const RestaurantSearchListPage({super.key});

  @override
  State<RestaurantSearchListPage> createState() =>
      _RestaurantSearchListPageState();
}

class _RestaurantSearchListPageState extends State<RestaurantSearchListPage> {
  late FocusNode _searchBarFocus;

  final TextEditingController _controllerSearchBar = TextEditingController();

  int _gridCrossAxisCount = 1;

  @override
  void initState() {
    super.initState();
    _searchBarFocus = FocusNode();
  }

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
      return _buildChangeNotifierProvider();
    });
  }

  Widget _buildChangeNotifierProvider() {
    return ChangeNotifierProvider<RestaurantsSearchListProvider>(
      create: (_) => RestaurantsSearchListProvider(
        apiService: ApiService(),
      ),
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarSearchBar(context),
      body: _buildConsumerRestaurantListProvider(),
    );
  }

  AppBar _buildAppBarSearchBar(BuildContext context) {
    return AppBar(
      title: const Text('Search Page'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: _searchBar(context),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: SearchBar(
        controller: _controllerSearchBar,
        backgroundColor: MaterialStateProperty.resolveWith(
            (_) => lightColorScheme.surfaceVariant),
        textStyle: MaterialStateProperty.resolveWith(
            (_) => TextStyle(color: lightColorScheme.onSurfaceVariant)),
        focusNode: _searchBarFocus..requestFocus(),
        trailing: [
          IconButton(
            onPressed: () {
              Provider.of<RestaurantsSearchListProvider>(context, listen: false)
                  .fetchSearchListRestaurant(_controllerSearchBar.text);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumerRestaurantListProvider() {
    return Consumer<RestaurantsSearchListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.notStarted) {
          return Center(
            child: Text(state.message),
          );
        } else if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          final restaurants = state.wrapRestaurants.restaurants;
          return _buildRestaurantsResult(
              context: context, restaurants: restaurants);
        } else if (state.state == ResultState.noData) {
          return FailedLoadRestaurant(message: state.message);
        } else if (state.state == ResultState.error) {
          return FailedLoadRestaurant(message: state.message);
        } else {
          return FailedLoadRestaurant(message: state.message);
        }
      },
    );
  }

  Widget _buildRestaurantsResult(
      {required BuildContext context, required List<Restaurant> restaurants}) {
    if (_gridCrossAxisCount == 1) {
      return _buildListView(restaurants);
    } else {
      return _buildGridView(context: context, restaurants: restaurants);
    }
  }

  ListView _buildListView(List<Restaurant> restaurants) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return CardListTileRestaurant(
          restaurants[index],
          () {
            Navigation.intentWithData(
              RestaurantDetailPage.routeName,
              restaurants[index].id,
            );
          },
        );
      },
    );
  }

  GridView _buildGridView(
      {required BuildContext context, required List<Restaurant> restaurants}) {
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
              Navigation.intentWithData(
                RestaurantDetailPage.routeName,
                restaurant.id,
              );
            },
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    _searchBarFocus.dispose();
    _controllerSearchBar.dispose();
    super.dispose();
  }
}
