import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/utils/database_helper.dart';

class DBProvider extends ChangeNotifier {
  List<Favorite> _favorites = [];
  late DatabaseHelper _dbHelper;

  List<Favorite> get favorites => _favorites;

  DBProvider() {
    _dbHelper = DatabaseHelper();
    getAllFavorites();
  }

  Future<void> addFavorite(Favorite favorite) async {
    await _dbHelper.insertFavorite(favorite);
    await getAllFavorites();
    notifyListeners();
  }

  Future<void> getAllFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    notifyListeners();
  }

  Future<Favorite?> getFavoriteById(String id) async {
    return await _dbHelper.getFavoriteById(id);
  }

  Future<void> updateFavorite(Favorite favorite) async {
    await _dbHelper.updateFavorite(favorite);
    await getAllFavorites();
    notifyListeners();
  }

  Future<void> deleteFavorite(String id) async {
    await _dbHelper.deleteFavorite(id);
    await getAllFavorites();
    notifyListeners();
  }
}
