import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  late RestaurantResult _restaurantResult;
  late ResultState _state;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurants();
  }

  String _message = '';

  String get message => _message;

  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.listRestaurant();
      if (restaurants.restaurants?.isEmpty ?? true) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        _restaurantResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
    } finally {
      notifyListeners();
    }
  }
}
