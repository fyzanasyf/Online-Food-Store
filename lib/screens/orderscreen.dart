import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/order_model.dart';

class OrderScreen extends StatefulWidget {
  final List<Product> cart;

  const OrderScreen({required this.cart, Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isPlacingOrder = false;

  double getTotalPrice() => widget.cart.fold(0, (sum, item) => sum + item.price);

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isPlacingOrder = true;
    });

    final order = OrderModel(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      products: widget.cart,
      total: getTotalPrice(),
    );

    try {
      await FirebaseFirestore.instance.collection('orders').add(order.toMap());

      // Close this screen
      Navigator.of(context).pop(true); // pass true to indicate order placed
    } catch (e) {
      // Show error on this screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error placing order: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? "Enter phone number" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPlacingOrder ? null : placeOrder,
                child: Text(_isPlacingOrder ? "Placing..." : "Place Order"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
