import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantResult> listRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    try {
      return RestaurantResult.fromJson(json.decode(response.body));
    } catch(e) {
      throw Exception('Error $e');
    }
  }

  Future<RestaurantDetailResult> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    try {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } catch(e) {
      throw Exception('Error $e');
    }
  }

  Future<RestaurantSearchResult> searchRestaurant(String keywords) async {
    final response =
      await http.get(Uri.parse("${_baseUrl}search?q=${keywords ?? ''}"));
    try {
      return RestaurantSearchResult.fromJson(json.decode(response.body));
    } catch(e) {
      throw Exception('Error $e');
    }
  }

  static String getBaseUrl() {
    return _baseUrl;
  }
}
