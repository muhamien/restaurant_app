import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/presentation/main/home.dart';
import 'package:restaurant_app/presentation/restaurant/detail_restaurent.dart';

class Routes {
  Routes._();

  static const String main = "/home";
  static const String detailRestaurant = "/detail_restaurant";

  static final routes = <String, WidgetBuilder>{
    main: (BuildContext context) => const HomeScreen(),
    detailRestaurant: (BuildContext context) {
      final restaurant =
          ModalRoute.of(context)!.settings.arguments as Restaurant;
      return DetailRestaurantScreen(restaurant: restaurant);
    },
  };
}
