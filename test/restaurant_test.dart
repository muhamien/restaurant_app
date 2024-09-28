import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

void main() {
  group('Restaurant Model Test', () {
    test('should parse RestaurantResult from JSON', () {
      final json = {
        "error": false,
        "message": "Success",
        "restaurants": [
          {
            "id": "1",
            "name": "Restaurant A",
            "description": "Delicious food",
            "pictureId": "picture_a.jpg",
            "city": "City A",
            "rating": 4.5,
            "categories": [
              {"name": "Category A"}
            ],
            "menus": {
              "foods": [
                {"name": "Food A"}
              ],
              "drinks": [
                {"name": "Drink A"}
              ]
            },
            "customerReviews": [
              {
                "name": "Customer A",
                "review": "Great place!",
                "date": "2023-01-01"
              }
            ]
          }
        ]
      };

      final result = RestaurantResult.fromJson(json);

      expect(result.error, false);
      expect(result.message, "Success");
      expect(result.restaurants!.length, 1);
      expect(result.restaurants![0].name, "Restaurant A");
      expect(result.restaurants![0].rating, 4.5);
    });

    test('should parse RestaurantDetailResult from JSON', () {
      final json = {
        "error": false,
        "message": "Success",
        "restaurant": {
          "id": "1",
          "name": "Restaurant A",
          "description": "Delicious food",
          "pictureId": "picture_a.jpg",
          "city": "City A",
          "rating": 4.5,
          "categories": [
            {"name": "Category A"}
          ],
          "menus": {
            "foods": [
              {"name": "Food A"}
            ],
            "drinks": [
              {"name": "Drink A"}
            ]
          },
          "customerReviews": [
            {
              "name": "Customer A",
              "review": "Great place!",
              "date": "2023-01-01"
            }
          ]
        }
      };

      final result = RestaurantDetailResult.fromJson(json);

      expect(result.error, false);
      expect(result.message, "Success");
      expect(result.restaurant.name, "Restaurant A");
      expect(result.restaurant.rating, 4.5);
    });

    test('should parse RestaurantSearchResult from JSON', () {
      final json = {
        "error": false,
        "founded": 1,
        "restaurants": [
          {
            "id": "1",
            "name": "Restaurant A",
            "description": "Delicious food",
            "pictureId": "picture_a.jpg",
            "city": "City A",
            "rating": 4.5
          }
        ]
      };

      final result = RestaurantSearchResult.fromJson(json);

      expect(result.error, false);
      expect(result.founded, 1);
      expect(result.restaurants!.length, 1);
      expect(result.restaurants![0].name, "Restaurant A");
    });
  });
}
