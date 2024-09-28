import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/utils/routes.dart';

class SearchRestaurantScreen extends StatefulWidget {
  const SearchRestaurantScreen({super.key});

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  List<Restaurant> restaurantSearchResults = [];
  String keywords = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantSearchProvider>(
      create: (context) => RestaurantSearchProvider(
          apiService: ApiService(), keywords: keywords),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: Container(
          margin: const EdgeInsets.only(top: 16.0),
          child: _searchResultList(),
        )),
      ),
    );
  }

  Widget _searchResultList() {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Consumer<RestaurantSearchProvider>(
                    builder: (context, provider, _) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Search restaurants...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (query) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 500), () {
                            setState(() {
                              keywords = query;
                            });
                            provider.setKeywords(query);
                          });
                        },
                      );
                    }
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Results",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                keywords != ''
                    ? Text(
                        "for \"$keywords\" ${restaurantSearchResults.isEmpty ? "is not found!" : ""}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const Text(
                        "Enter your keywords",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ],
            ),
          ),
          Consumer<RestaurantSearchProvider>(
              builder: (context, provider, _) {
            restaurantSearchResults =
                provider.result?.restaurants!.toList() ?? [];
            switch (provider.state) {
              case ResultState.loading:
                return Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              case ResultState.hasData:
                return Expanded(
                  child: ListView.builder(
                    itemCount: restaurantSearchResults.length,
                    itemBuilder: (context, index) {
                      return _buildSearchItem(restaurantSearchResults[index]);
                    },
                  ),
                );
              case ResultState.noData:
                return const Expanded(
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty_sharp,
                            size: 100,
                            color: Colors.black54,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Not Found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                  ),
                );
              case ResultState.error:
                return const Text("err");
              default:
                return const Expanded(
                  child: Center(
                    child: Column(
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
                  ),
                );
            }
          })
        ],
      ),
    );
  }

  Widget _buildSearchItem(Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.detailRestaurant,
            arguments: restaurant);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: "suggested-item-${restaurant.pictureId}",
                child: Image.network(
                  '${ApiService.getBaseUrl()}/images/medium/${restaurant.pictureId}',
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${restaurant.rating}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(95, 196, 196, 196),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, left: 8, right: 8),
                    child: Text(
                      restaurant.city,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
