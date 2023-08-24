import 'package:flutter/material.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';

// ignore: must_be_immutable
class CardListTileRestaurant extends StatelessWidget {
  late Restaurant _restaurant;

  final _url = 'https://restaurant-api.dicoding.dev/images/small/';
  final void Function() onTap;

  final textStyleListTileDesc = const TextStyle(fontSize: 18);
  final sizedBoxWidthListTileDesc = const SizedBox(height: 5);

  CardListTileRestaurant(Restaurant restaurant, this.onTap, {super.key}) {
    _restaurant = Restaurant(
        id: restaurant.id,
        name: restaurant.name,
        description: restaurant.description,
        pictureId: restaurant.pictureId,
        city: restaurant.city,
        rating: restaurant.rating);
  }

  @override
  Widget build(BuildContext context) {
    var primaryCustom = lightColorScheme.primary.withAlpha(30);
    return Card(
      child: ListTile(
        splashColor: primaryCustom,
        hoverColor: primaryCustom,
        leading: Hero(
          tag: _restaurant.pictureId,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: (_url + _restaurant.pictureId),
            width: 100,
          ),
        ),
        titleAlignment: ListTileTitleAlignment.top,
        title: Text(
          _restaurant.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on),
                sizedBoxWidthListTileDesc,
                Text(
                  _restaurant.city,
                  style: textStyleListTileDesc,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(Icons.star_rate),
                sizedBoxWidthListTileDesc,
                Text(
                  _restaurant.rating.toString(),
                  style: textStyleListTileDesc,
                ),
              ],
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
