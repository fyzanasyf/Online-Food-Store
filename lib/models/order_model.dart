import 'product.dart';

class OrderModel {
  final String name;
  final String phone;
  final String address;
  final List<Product> products;
  final double total;
  final String paymentMethod;

  OrderModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.products,
    required this.total,
    this.paymentMethod = "Cash on Delivery",
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'products': products.map((product) {
        return {
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
        };
      }).toList(),
      'total': total,
      'paymentMethod': paymentMethod,
      'createdAt': DateTime.now(),
    };
  }
}
