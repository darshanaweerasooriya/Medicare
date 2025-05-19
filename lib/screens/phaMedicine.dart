import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PharmacistMedicineScreen extends StatefulWidget {
  @override
  _PharmacistMedicineScreenState createState() => _PharmacistMedicineScreenState();
}

class _PharmacistMedicineScreenState extends State<PharmacistMedicineScreen> {
  List<Map<String, dynamic>> medicines = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMedicinesFromBackend();
  }

  Future<void> fetchMedicinesFromBackend() async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/products'); // Replace with your backend URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<Map<String, dynamic>> backendMedicines = [];

        if (decoded is List) {
          backendMedicines = decoded.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
        } else if (decoded is Map<String, dynamic> && decoded.containsKey('products')) {
          if (decoded['products'] is List) {
            backendMedicines = (decoded['products'] as List)
                .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
                .toList();
          }
        }

        setState(() {
          medicines = backendMedicines;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load medicines (Status: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching medicines: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Added Medicines'),
        backgroundColor: Color(0xFF7165D6),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : medicines.isEmpty
          ? Center(
        child: Text(
          'No medicines added yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          final imageBase64 = medicine['image'];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: imageBase64 != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(imageBase64),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.medical_services, size: 32),
              ),
              title: Text(
                medicine['productname'] ?? 'Unnamed Medicine',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Brand: ${medicine['brand'] ?? 'Unknown'}\nPrice: ${medicine['price'] ?? 'N/A'}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
