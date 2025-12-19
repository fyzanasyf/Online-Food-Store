import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Store Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/store.png", // 👈 put any store-related image in assets
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              "Welcome to Shopping Store 🛍️",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Description
            Text(
              "We bring you the best quality food and products at affordable prices. "
                  "Our mission is to make shopping easier, faster, and more enjoyable for everyone. "
                  "From delicious meals 🍔🍕 to everyday essentials, we've got you covered!",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Cards with features
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.local_shipping, color: Colors.blue),
                title: Text("Fast Delivery"),
                subtitle: Text("Get your order delivered within 30 minutes!"),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.orange),
                title: Text("Top Quality"),
                subtitle: Text("Only the best items are selected for you."),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.support_agent, color: Colors.green),
                title: Text("24/7 Support"),
                subtitle: Text("We’re here to help anytime, anywhere."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
