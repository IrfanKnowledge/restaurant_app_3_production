import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/ui/restaurant_bookmark_list_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/restaurant_search_page.dart';
import 'package:restaurant_app/ui/settings_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/widgets/card_list_tile_restaurant.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/failed_load_restaurant.dart';

// ignore: must_be_immutable
class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list_page';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  int _gridCrossAxisCount = 1;

  @override
  void initState() {
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _buildLayoutBuilder();

  /// set [_gridCrossAxisCount] to choose between [_buildSliverList] or [_buildSliverGrid], if [_buildSliverGrid] then choose the crossAxisCount
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
      return Scaffold(body: _buildChangeNotifierProvider());
    });
  }

  /// build [_buildChangeNotifierProvider] as a parent of [_buildConsumerRestaurantListProvider]
  Widget _buildChangeNotifierProvider() {
    return ChangeNotifierProvider<RestaurantListProvider>(
      create: (_) => RestaurantListProvider(apiService: ApiService()),
      child: _buildConsumerRestaurantListProvider(),
    );
  }

  /// build [_buildConsumerRestaurantListProvider] to consume data (RestaurantList) and checking progress status of fetching data from API,
  /// then decide what to do based on the differences of each progress status
  Widget _buildConsumerRestaurantListProvider() {
    return Consumer<RestaurantListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          final restaurants = state.wrapRestaurants.restaurants;
          return _buildCustomScrollView(
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

  /// build [_buildSliverAppBar] and ( [_buildSliverList] or [_buildSliverGrid] )
  CustomScrollView _buildCustomScrollView(
      {required BuildContext context, required List<Restaurant> restaurants}) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildSliverAppBar(context),
        _buildSliverRestaurants(context: context, restaurants: restaurants),
      ],
    );
  }

  /// build AppBar but with Sliver style
  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      automaticallyImplyLeading: true,
      expandedHeight: 200,
      actions: [
        _buildActionIconButton(
          RestaurantSearchListPage.routeName,
          Icons.search,
        ),
        _buildActionIconButton(
          RestaurantBookmarkListPage.routeName,
          Icons.favorite,
        ),
        _buildActionIconButton(
          SettingsPage.routeName,
          Icons.settings,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/restaurant.png',
          fit: BoxFit.contain,
        ),
      ),
      bottom: _buildPreferredSize(context),
    );
  }

  /// build [_buildActionIconButton] for [_buildSliverAppBar.actions]
  Widget _buildActionIconButton(String routeName, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: lightColorScheme.surfaceVariant.withOpacity(0.9),
        child: IconButton(
          onPressed: () {
            Navigation.intentWithoutData(routeName);
          },
          icon: Icon(
            iconData,
            color: lightColorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// build [_buildPreferredSize] for [_buildSliverAppBar.bottom]
  PreferredSize _buildPreferredSize(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 300,
              decoration: BoxDecoration(
                color: lightColorScheme.surfaceVariant.withOpacity(0.9),
                border: Border.all(
                    color: lightColorScheme.onSurfaceVariant, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restaurant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Cobalah Restaurant terbaik di sekitar anda!',
                    style: TextStyle(color: lightColorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// choose between to [_buildSliverList] or [_buildSliverGrid], if [_buildSliverGrid] then choose the crossAxisCount
  Widget _buildSliverRestaurants(
      {required BuildContext context, required List<Restaurant> restaurants}) {
    var padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    if (_gridCrossAxisCount == 1) {
      return SliverPadding(
        padding: padding,
        sliver: _buildSliverList(context: context, restaurants: restaurants),
      );
    } else {
      return SliverPadding(
        padding: padding,
        sliver: _buildSliverGrid(context: context, restaurants: restaurants),
      );
    }
  }

  /// build ListView but with Sliver style
  SliverList _buildSliverList(
      {required BuildContext context, required List<Restaurant> restaurants}) {
    return SliverList(
      delegate: SliverChildListDelegate(
        restaurants
            .map(
              (restaurant) => CardListTileRestaurant(
                restaurant,
                () {
                  Navigation.intentWithData(
                    RestaurantDetailPage.routeName,
                    restaurant.id,
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  /// build GridView but with Sliver style
  SliverGrid _buildSliverGrid(
      {required BuildContext context, required List<Restaurant> restaurants}) {
    return SliverGrid.count(
      crossAxisCount: _gridCrossAxisCount,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: restaurants
          .map(
            (restaurant) => CardRestaurant(
              restaurant,
              () {
                Navigation.intentWithData(
                  RestaurantDetailPage.routeName,
                  restaurant.id,
                );
              },
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
