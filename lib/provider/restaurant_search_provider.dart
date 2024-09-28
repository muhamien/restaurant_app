import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  RestaurantSearchResult? _restaurantSearchResult;
  late ResultState _state;
  String keywords = '';

  RestaurantSearchProvider({required this.apiService, required this.keywords}) {
    searchRestaurant();
  }

  String _message = '';

  String get message => _message;

  RestaurantSearchResult? get result => _restaurantSearchResult;
  ResultState get state => _state;

  Future<dynamic> searchRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.searchRestaurant(keywords);
      if (restaurants.restaurants == null || restaurants.restaurants!.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        _restaurantSearchResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
    } finally {
      notifyListeners();
    }
  }


  void setKeywords(String newKeywords) async{
    if (newKeywords == keywords) return;
    keywords = newKeywords;
    await searchRestaurant();
  }
}
