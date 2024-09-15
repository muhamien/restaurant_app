import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  late RestaurantDetailResult _restaurantDetailResult;
  late ResultState _state;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    fetchRestaurantDetails(id);
  }

  String _message = '';
  String get message => _message;

  RestaurantDetailResult get result => _restaurantDetailResult;
  ResultState get state => _state;

  Future<dynamic> fetchRestaurantDetails(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.detailRestaurant(id);
      if (restaurant.restaurant == null) {
        _state = ResultState.noData;
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantDetailResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
    } finally {
      notifyListeners();
    }
  }
}
