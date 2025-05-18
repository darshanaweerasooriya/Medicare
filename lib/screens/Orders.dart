import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // Mock data for demonstration
  List<Map<String, dynamic>> orders = [
    {
      'userId': 'U123',
      'medicine': 'Paracetamol',
      'quantity': 2,
      'status': 'Pending',
    },
    {
      'userId': 'U456',
      'medicine': 'Amoxicillin',
      'quantity': 1,
      'status': 'Confirmed',
    },
    {
      'userId': 'U789',
      'medicine': 'Ibuprofen',
      'quantity': 3,
      'status': 'Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Orders"),
        backgroundColor: Color(0xFF7165D6),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                "Medicine: ${order['medicine']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User ID: ${order['userId']}"),
                  Text("Quantity: ${order['quantity']}"),
                  Text("Status: ${order['status']}"),
                ],
              ),
              trailing: Icon(Icons.medication, color: Color(0xFF7165D6)),
            ),
          );
        },
      ),
    );
  }
}