import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/category_model.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/utils/result_state_helper.dart';
import 'package:restaurant_app/widgets/failed_load_restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail_page';

  late Restaurant restaurant;
  final String path;

  RestaurantDetailPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider();
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return RestaurantDetailProvider(
              apiService: ApiService(),
              restaurantId: path,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ],
      child: _buildConsumerRestaurantDetailProvider(),
    );
  }

  Widget _buildConsumerRestaurantDetailProvider() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, restDetailProv, _) {
        if (restDetailProv.state == ResultState.loading) {
          return _buildScaffoldWithLoading();
        } else if (restDetailProv.state == ResultState.hasData) {
          final restaurant = restDetailProv.wrapRestaurant.restaurant;
          this.restaurant = restaurant;
          return _buildScaffoldData(context);
        } else if (restDetailProv.state == ResultState.noData) {
          return _buildScaffoldWithMessage(restDetailProv.message);
        } else if (restDetailProv.state == ResultState.error) {
          return _buildScaffoldWithMessage(restDetailProv.message);
        } else {
          return _buildScaffoldWithMessage(restDetailProv.message);
        }
      },
    );
  }

  Scaffold _buildScaffoldWithLoading() {
    return Scaffold(
      body: FailedLoadRestaurant(
        message: '',
        isLoading: true,
      ),
    );
  }

  Scaffold _buildScaffoldWithMessage(String message) {
    return Scaffold(
      body: FailedLoadRestaurant(
        message: message,
      ),
    );
  }

  Scaffold _buildScaffoldData(BuildContext context) {
    const sizedBoxHeightMed = SizedBox(height: 10);
    const sizedBoxHeightSmall = SizedBox(height: 5);

    const url = 'https://restaurant-api.dicoding.dev/images/medium/';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    Hero(
                      tag: restaurant.pictureId,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: (url + restaurant.pictureId),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: lightColorScheme.surfaceVariant
                                .withOpacity(0.9),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: lightColorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildIconButtonBookmarkedRestaurant(),
                    ],
                  ),
                  sizedBoxHeightSmall,
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  sizedBoxHeightSmall,
                  _buildRowAfterNameBeforeDesc(
                    Icons.location_on,
                    restaurant.city,
                  ),
                  sizedBoxHeightSmall,
                  _buildRowAfterNameBeforeDesc(
                    Icons.star_rate,
                    restaurant.rating.toString(),
                  ),
                  sizedBoxHeightMed,
                  _buildContainerLabel('Deskripsi:'),
                  sizedBoxHeightSmall,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.description,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeightMed,
                  _buildContainerLabel('Makanan:'),
                  sizedBoxHeightSmall,
                  _buildContainerMenusList(restaurant.menus.foods),
                  sizedBoxHeightMed,
                  _buildContainerLabel('Minuman:'),
                  sizedBoxHeightSmall,
                  _buildContainerMenusList(restaurant.menus.drinks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButtonBookmarkedRestaurant() {
    return Consumer<DatabaseProvider>(
      builder: (_, data, __) {
        return FutureBuilder<bool>(
          future: data.isRestaurantBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            var icon = isBookmarked
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border);

            if (isBookmarked) {
              return IconButton(
                onPressed: () {
                  data.removeRestaurantBookmark(restaurant.id);
                },
                icon: icon,
              );
            }

            return IconButton(
              onPressed: () {
                data.addRestaurantBookmark(restaurant);
              },
              icon: icon,
            );
          },
        );
      },
    );
  }

  Row _buildRowAfterNameBeforeDesc(IconData iconData, String item) {
    const sizedBoxWidthSmall = SizedBox(width: 5);

    return Row(
      children: [
        Icon(iconData),
        sizedBoxWidthSmall,
        Text(
          item,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Container _buildContainerLabel(String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: lightColorScheme.secondary,
      ),
      child: Text(
        label,
        style: TextStyle(
            color: lightColorScheme.onSecondary,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _buildContainerMenusList(List<Category> menus) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
      color: lightColorScheme.tertiary,
      child: _buildListViewRestaurantMenus(menus),
    );
  }

  ListView _buildListViewRestaurantMenus(List<Category> menus) {
    var primaryCustom = lightColorScheme.primary.withAlpha(30);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return Card(
          color: lightColorScheme.surface,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: primaryCustom,
            highlightColor: primaryCustom,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                menus[index].name,
                style: TextStyle(
                    color: lightColorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
