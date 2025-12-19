import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/product.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// 🌟 Root app (starts with Login screen)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Food Store',
      home: LoginScreen(),
    );
  }
}

// 🏪 Main Store App after Login
class MyStoreApp extends StatefulWidget {
  const MyStoreApp({super.key});

  @override
  State<MyStoreApp> createState() => _MyStoreAppState();
}

class _MyStoreAppState extends State<MyStoreApp> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  List<Product> cart = [];
  List<Product> favorites = [];

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onSelectScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () => _onSelectScreen(index),
      hoverColor: Colors.orange.withOpacity(0.3),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Clear cart and favorites
              setState(() {
                cart.clear();
                favorites.clear();
              });

              // Navigate to LoginScreen and remove all previous routes
              Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(), // 0
      ProductsScreen(
        onAddToCart: (product) {
          setState(() {
            cart.add(product);
          });
        },
        onAddToFavorites: (product) {
          setState(() {
            favorites.add(product);
          });
        },
      ), // 1
      FavoritesScreen(favorites: favorites), // 2
      CartScreen(cart: cart), // 3
      AboutScreen(), // 4
      ContactScreen(), // 5
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Online Food Store"),
          backgroundColor: Colors.orange,
          elevation: 0,
        ),

        // 🌈 Stylish Drawer with Glass Effect
        drawer: Drawer(
          backgroundColor: Colors.orange.withOpacity(0.85),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage("assets/logo.jpg"),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Online Food Store",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Text(
                      "faizan8182@gmail.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white38, indent: 30, endIndent: 30),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(Icons.home, "Home", 0),
                _buildDrawerItem(Icons.restaurant_menu, "Products", 1),
                _buildDrawerItem(Icons.favorite, "Favorites", 2),
                _buildDrawerItem(Icons.shopping_cart, "Cart", 3),
                _buildDrawerItem(Icons.info, "About", 4),
                _buildDrawerItem(Icons.contact_mail, "Contact", 5),
                const SizedBox(height: 15),
                const Divider(color: Colors.white30, indent: 30, endIndent: 30),
                SwitchListTile(
                  title: const Text("Dark Mode",
                      style: TextStyle(color: Colors.white)),
                  value: _isDarkMode,
                  onChanged: (val) {
                    toggleTheme();
                  },
                  secondary:
                  const Icon(Icons.nightlight_round, color: Colors.white),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("Logout",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onTap: _logout,
                  hoverColor: Colors.red.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),

        // 🧭 Body + Curved Navigation Bar
        body: screens[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor: Colors.transparent,
          color: Colors.orange,
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.restaurant_menu, size: 30, color: Colors.white),
            Icon(Icons.favorite, size: 30, color: Colors.white),
            Icon(Icons.shopping_cart, size: 30, color: Colors.white),
            Icon(Icons.info, size: 30, color: Colors.white),
            Icon(Icons.contact_mail, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
