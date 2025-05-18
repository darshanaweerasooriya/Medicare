import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class ViewAllproducts extends StatefulWidget {
  const ViewAllproducts({super.key});

  @override
  State<ViewAllproducts> createState() => _ViewAllproductsState();
}

class _ViewAllproductsState extends State<ViewAllproducts> {
  List<dynamic> products = [];
  bool isLoading = true;

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://10.0.2.2:3000/products'); // Replace with your backend

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          products = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Widget buildProductCard(dynamic product) {
    String? base64Image = product['image']?['data'];
    Uint8List? imageBytes =
    base64Image != null ? base64Decode(base64Image) : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: imageBytes != null
                ? Image.memory(imageBytes, height: 180, width: double.infinity, fit: BoxFit.cover)
                : Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['productname']?.toString().toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("Brand: ${product['brand'] ?? ''}"),
                Text("Price: Rs. ${product['price'] ?? ''}"),
                const SizedBox(height: 8),
                Text(product['description'] ?? ''),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add your order logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ordered ${product['productname']}")),
                );
              },
              child: const Text("Order Now"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildProductCard(products[index]);
        },
      ),
    );
  }
}