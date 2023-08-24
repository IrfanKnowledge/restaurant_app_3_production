import 'package:flutter/material.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:restaurant_app/data/model/restaurant_list_model.dart';

// ignore: must_be_immutable
class CardRestaurant extends StatelessWidget {
  late Restaurant _restaurant;

  final _url = 'https://restaurant-api.dicoding.dev/images/small/';
  final void Function() onTap;

  final _sizedBoxHeightSmall = const SizedBox(height: 8);
  final textStyleDesc = const TextStyle(fontSize: 18);
  final sizedBoxWidthDesc = const SizedBox(height: 5);

  CardRestaurant(Restaurant restaurant, this.onTap, {super.key}) {
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
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: lightColorScheme.primary.withAlpha(30),
        highlightColor: lightColorScheme.primary.withAlpha(30),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: (_url + _restaurant.pictureId),
                fit: BoxFit.cover,
              ),
            ),
            _sizedBoxHeightSmall,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                _restaurant.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _sizedBoxHeightSmall,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  sizedBoxWidthDesc,
                  Text(
                    _restaurant.city,
                    style: textStyleDesc,
                  ),
                ],
              ),
            ),
            _sizedBoxHeightSmall,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  const Icon(Icons.star_rate),
                  sizedBoxWidthDesc,
                  Text(
                    _restaurant.rating.toString(),
                    style: textStyleDesc,
                  ),
                ],
              ),
            ),
            _sizedBoxHeightSmall,
          ],
        ),
      ),
    );
  }
}
