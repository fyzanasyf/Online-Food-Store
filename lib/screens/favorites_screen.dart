import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Product> favorites;

  FavoritesScreen({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return Card(
            child: ListTile(
              leading: Image.asset(
                product.imageUrl,
                width: 50,
                height: 50,
              ),
              title: Text(product.name),
              subtitle: Text("\$${product.price}"),
            ),
          );
        },
      ),
    );
  }
}
