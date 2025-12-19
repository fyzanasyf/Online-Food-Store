import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We’d love to hear from you! 💬",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Contact Card 1
            Card(
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text("Email"),
                subtitle: Text("onlineshoppingstore@shoppingstore.com"),
              ),
            ),

            // Contact Card 2
            Card(
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.blue),
                title: Text("Phone"),
                subtitle: Text("+92 300 1234567"),
              ),
            ),

            // Contact Card 3
            Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.green),
                title: Text("Address"),
                subtitle: Text("College Chowk Street no. 2, Sahiwal, Pakistan"),
              ),
            ),

            SizedBox(height: 20),

            // Contact Form Style Buttons
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.message),
              label: Text("Chat with Support"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.feedback),
              label: Text("Send Feedback"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
