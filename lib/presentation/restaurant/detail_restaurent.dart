import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/db_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';

class DetailRestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const DetailRestaurantScreen({super.key, required this.restaurant});

  @override
  DetailRestaurantScreenState createState() => DetailRestaurantScreenState();
}

class DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  List<MenuItem> foods = [];
  List<MenuItem> drinks = [];
  bool loading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(
            apiService: ApiService(),
            id: widget.restaurant.id,
          ),
        ),
        ChangeNotifierProvider<DBProvider>(
          create: (_) => DBProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.restaurant.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 38, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Consumer<DBProvider>(
              builder: (context, provider, child) {
                isFavorite = provider.favorites.any((favorite) => favorite.id == widget.restaurant.id);
                return IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 28,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    final favorite = Favorite(
                      id: widget.restaurant.id,
                      name: widget.restaurant.name,
                      description: widget.restaurant.description,
                      pictureId: widget.restaurant.pictureId,
                      city: widget.restaurant.city,
                      rating: widget.restaurant.rating,
                    );

                    if (isFavorite) {
                      provider.deleteFavorite(widget.restaurant.id);
                    } else {
                      provider.addFavorite(favorite);
                    }
                  },
                );
              },
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<RestaurantDetailProvider>(
                  builder: (context, provider, child) {
                    switch (provider.state) {
                      case ResultState.loading:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              _buildImageView(),
                              const Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            ],
                          ),
                        );
                      case ResultState.hasData:
                        return Column(
                          children: [
                            _buildImageView(),
                            const SizedBox(height: 18),
                            _buildDetailView(),
                          ],
                        );
                      default:
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.signal_wifi_off,
                                size: 100,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "You are offline",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Please check your connection",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return Hero(
      tag: "suggested-item-${widget.restaurant.pictureId}",
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            )),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              '${ApiService.getBaseUrl()}/images/medium/${widget.restaurant.pictureId}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCityInfo(),
          _buildRestaurantName(),
          _buildRestaurantDescription(),
          _buildCustomerReview(),
          _buildMenuList()
        ],
      ),
    );
  }

  Widget _buildCityInfo() {
    return Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
      final detail = provider.result.restaurant;
      final categories = detail.categories;
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              widget.restaurant.city,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          categories!.isNotEmpty
              ? Row(
                  children: [
                    const SizedBox(width: 8),
                    ...categories.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          item.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                  ],
                )
              : const SizedBox(),
          const SizedBox(width: 8),
          _buildRatingAndMenuInfo(),
        ],
      );
    });
  }

  Widget _buildRestaurantName() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(
        widget.restaurant.name,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRestaurantDescription() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(
        widget.restaurant.description,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildRatingAndMenuInfo() {
    return Row(
      children: [
        _buildRatingInfo(),
        const SizedBox(width: 14),
      ],
    );
  }

  Widget _buildRatingInfo() {
    return Row(
      children: [
        Text(
          '${widget.restaurant.rating}',
          style: const TextStyle(fontSize: 14),
        ),
        Icon(
          Icons.star,
          size: 18,
          color: Colors.amber[800],
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            "Menu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        _buildFoodList(),
        _buildDrinkList(),
      ],
    );
  }

  Widget _buildFoodList() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        final foods = provider.result.restaurant.menus?.foods ?? [];
        if (foods.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  "Foods",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ...foods.map((food) {
                return ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.red),
                  title: Text(food.name),
                );
              }),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDrinkList() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        var drinks = provider.result.restaurant.menus?.drinks ?? [];
        if (drinks.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  "Drinks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ...drinks.map((drink) {
                return ListTile(
                  leading: const Icon(Icons.local_drink, color: Colors.blue),
                  title: Text(drink.name),
                );
              }),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildCustomerReview() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        final reviews = provider.result.restaurant.customerReview ?? [];
        if (reviews.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Customer Reviews",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              ...reviews.map((review) {
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.grey),
                  title: Text(review.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.review),
                      Text(
                        review.date, // Assuming review.date is a String
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            "No reviews yet.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        );
      },
    );
  }
}
