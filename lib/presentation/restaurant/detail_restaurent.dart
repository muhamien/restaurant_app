import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(
        apiService: ApiService(),
        id: widget.restaurant.id,
      ),
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
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageView(),
                const SizedBox(height: 18),
                _buildDetailView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return Hero(
      tag: widget.restaurant.pictureId.toString(),
      child: ClipRRect(
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
          _buildMenuList()
        ],
      ),
    );
  }

  Widget _buildCityInfo() {
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
        const SizedBox(width: 8),
        _buildRatingAndMenuInfo(),
      ],
    );
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
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
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
        return Center(child: Text(provider.message));
      },
    );
  }

  Widget _buildFoodList() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        var foods = provider.result!.restaurant?.menus?.foods ?? [];
        if (foods.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        var drinks = provider.result!.restaurant?.menus?.drinks ?? [];
        if (drinks.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
}
