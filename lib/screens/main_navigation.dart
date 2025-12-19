import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Import your existing screens
import 'home_screen.dart';
import 'products_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'about_screen.dart';
import '../models/product.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Temporary lists for cart and favorites
  final List<Product> cart = [];
  final List<Product> favorites = [];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      ProductsScreen(
        onAddToCart: (product) => setState(() => cart.add(product)),
        onAddToFavorites: (product) => setState(() => favorites.add(product)),
      ),
      FavoritesScreen(favorites: favorites),
      CartScreen(cart: cart),
      AboutScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: Colors.orange,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.restaurant_menu, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.info, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
