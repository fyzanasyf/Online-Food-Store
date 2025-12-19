import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  final Function(Product) onAddToCart;
  final Function(Product) onAddToFavorites;

  ProductsScreen({required this.onAddToCart, required this.onAddToFavorites});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Keep track of which items are in favorites
  final Set<Product> favoriteItems = {};

  final List<Product> products = [
    Product(name: "Burger", price: 5.99, imageUrl: "assets/images/burger.png"),
    Product(name: "Pizza", price: 8.99, imageUrl: "assets/images/pizza.png"),
    Product(name: "Pasta", price: 6.49, imageUrl: "assets/images/pasta.png"),
    Product(name: "Sandwich", price: 4.99, imageUrl: "assets/images/sandwich.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favoriteItems.contains(product);

        return Card(
          child: ListTile(
            leading: Image.asset(product.imageUrl, width: 50, height: 50),
            title: Text(product.name),
            subtitle: Text("\$${product.price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ❤️ Favorite Button
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        favoriteItems.remove(product);
                      } else {
                        favoriteItems.add(product);
                        widget.onAddToFavorites(product);
                      }
                    });
                  },
                ),
                // 🛒 Add to Cart Button
                IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.green),
                  onPressed: () {
                    widget.onAddToCart(product);

                    // Show message when added to cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product.name} added to cart"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

