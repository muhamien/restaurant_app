import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/db_provider.dart';
import 'package:restaurant_app/utils/routes.dart';

class FavoriteScreen extends StatefulWidget{
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>{

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
    return ChangeNotifierProvider<DBProvider>(
    create: (_) => DBProvider(),
    child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 38, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<DBProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
                onPressed: () {
                  provider.getAllFavorites();
                },
              );
            }
          ),
        ],
      ),
      body: Consumer<DBProvider>(
          builder: (context, provider, child) {
            final favorites = provider.favorites;
            
            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites found.', style: TextStyle(color: Colors.white),));
            } else {
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, Routes.detailRestaurant,
                        arguments: Restaurant(
                          id: favorite.id!,
                          name: favorite.name!,
                          description: favorite.description!,
                          pictureId: favorite.pictureId!,
                          city: favorite.city!,
                          rating: favorite.rating!,
                        ));
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(favorite.name ?? 'No Name'),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

      
