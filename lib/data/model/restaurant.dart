class RestaurantResult {
  bool error;
  String message;
  List<Restaurant>? restaurants;

  RestaurantResult({
    required this.error,
    required this.message,
    this.restaurants,
  });

  factory RestaurantResult.fromJson(Map<String, dynamic> json) =>
    RestaurantResult(
      error: json["error"],
      message: json["message"],
      restaurants: json["restaurants"] != null
          ? List<Restaurant>.from(
              json["restaurants"].map((x) => Restaurant.fromJson(x)),
            )
          : null,
    );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "restaurants": restaurants != null
        ? List<dynamic>.from(restaurants!.map((x) => x.toJson()))
        : null,
  };
}

class RestaurantDetailResult {
  bool error;
  String message;
  Restaurant restaurant;

  RestaurantDetailResult({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResult.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResult(
        error: json["error"],
        message: json["message"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
      );
}

class RestaurantSearchResult {
  bool error;
  int founded;
  List<Restaurant>? restaurants;

  RestaurantSearchResult({
    required this.error,
    required this.founded,
    this.restaurants,
  });

  factory RestaurantSearchResult.fromJson(Map<String, dynamic> json) =>
      RestaurantSearchResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: json["restaurants"] != null
            ? List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x)),
              )
            : null,
      );
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  List<CategoryRestaurant>? categories;
  Menu? menu;
  List<CustomerReview>? customerReview;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.categories,
    this.menu,
    this.customerReview,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
        categories: json["categories"] != null
            ? List<CategoryRestaurant>.from(
                json["categories"].map((x) => CategoryRestaurant.fromJson(x)))
            : null,
        menu: json["menu"] != null
            ? Menu.fromJson(json["menu"]) // Parse menu properly
            : null,
        customerReview: json["customerReviews"] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "pictureId": pictureId,
      "city": city,
      "rating": rating,
      "categories": categories != null
          ? List<dynamic>.from(categories!.map((x) => x.toJson()))
          : null,
      "menu": menu?.toJson(),
      "customerReviews": customerReview != null
          ? List<dynamic>.from(customerReview!.map((x) => x.toJson()))
          : null,
    };
  }
}

class CategoryRestaurant {
  String name;

  CategoryRestaurant({required this.name});

  factory CategoryRestaurant.fromJson(Map<String, dynamic> json) {
    return CategoryRestaurant(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview(
      {required this.name, required this.review, required this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var foodsFromJson = json['foods'] as List;
    var drinksFromJson = json['drinks'] as List;

    List<MenuItem> foodList =
        foodsFromJson.map((i) => MenuItem.fromJson(i)).toList();
    List<MenuItem> drinkList =
        drinksFromJson.map((i) => MenuItem.fromJson(i)).toList();

    return Menu(
      foods: foodList,
      drinks: drinkList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foods': foods.map((food) => food.toJson()).toList(),
      'drinks': drinks.map((drink) => drink.toJson()).toList(),
    };
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
