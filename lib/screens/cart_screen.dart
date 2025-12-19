import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;

  CartScreen({required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotalPrice() {
    return widget.cart.fold(0, (sum, item) => sum + item.price);
  }

  void proceedToOrder() {
    if (widget.cart.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Cart Empty"),
          content: const Text("Your cart is empty 🛒"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _nameController = TextEditingController();
        final _phoneController = TextEditingController();
        final _addressController = TextEditingController();
        bool _isPlacingOrder = false;

        Future<void> placeOrder() async {
          if (!_formKey.currentState!.validate()) return;

          setState(() {
            _isPlacingOrder = true;
          });

          Map<String, dynamic> order = {
            'name': _nameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'products': widget.cart
                .map((p) => {
              'name': p.name,
              'price': p.price,
              'imageUrl': p.imageUrl,
            })
                .toList(),
            'total': getTotalPrice(),
            'paymentMethod': 'Cash on Delivery',
            'timestamp': DateTime.now(),
          };

          try {
            await FirebaseFirestore.instance.collection('orders').add(order);

            // Close the order form dialog
            Navigator.of(context).pop();

            // Show success popup dialog
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Success"),
                content: const Text("✅ Order placed successfully!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );

            setState(() {
              widget.cart.clear();
            });
          } catch (e) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Error"),
                content: Text("Error placing order: $e"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          } finally {
            setState(() {
              _isPlacingOrder = false;
            });
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Enter your details"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Full Name"),
                        validator: (val) => val!.isEmpty ? "Enter your name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: "Phone Number"),
                        keyboardType: TextInputType.phone,
                        validator: (val) => val!.isEmpty ? "Enter phone number" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: "Address"),
                        maxLines: 3,
                        validator: (val) => val!.isEmpty ? "Enter address" : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isPlacingOrder ? null : () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _isPlacingOrder ? null : placeOrder,
                  child: Text(_isPlacingOrder ? "Placing..." : "Place Order"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: widget.cart.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty 🛒",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cart[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    leading: Image.asset(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(product.name),
                    subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.cart.removeAt(index);
                        });
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Removed"),
                            content: Text("${product.name} removed from cart."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Total + Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${getTotalPrice().toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: proceedToOrder,
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text("Proceed to Order"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
