import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicineProductScreen extends StatefulWidget {
  @override
  _MedicineProductScreenState createState() => _MedicineProductScreenState();
}

class _MedicineProductScreenState extends State<MedicineProductScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHardcodedProducts();
    fetchMedicineProducts();
  }

  void loadHardcodedProducts() {
    products.addAll([
      {
        "productname": "Panadol",
        "brand": "GSK",
        "price": "Rs. 120",
        "image": null,
      },
      {
        "productname": "Vitamin C",
        "brand": "Hemas",
        "price": "Rs. 300",
        "image": null,
      },
      {
        "productname": "Betadine",
        "brand": "Avro",
        "price": "Rs. 250",
        "image": null,
      },
      {
        "productname": "Salbutamol Inhaler",
        "brand": "Cipla",
        "price": "Rs. 780",
        "image": null,
      },
    ]);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchMedicineProducts() async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<dynamic> backendProducts = [];

        if (decoded is List) {
          backendProducts =
              decoded.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (decoded is Map<String, dynamic> &&
            decoded.containsKey('products')) {
          if (decoded['products'] is List) {
            backendProducts = (decoded['products'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
          }
        }

        if (backendProducts.isNotEmpty) {
          setState(() {
            products = backendProducts;
          });
        }
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  void handleBuyNow(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(
          productName: product['productname'] ?? 'the product',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Products"),
        backgroundColor: Color(0xFF7165D6),
      ),
      body: products.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final product = Map<String, dynamic>.from(products[index]);
          final imageBase64 = product['image'];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBase64 != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: Image.memory(
                    base64Decode(imageBase64),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12)),
                  ),
                  child: Icon(Icons.medical_services, size: 40),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['productname'] ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Brand: ${product['brand']}"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Price: ${product['price']}"),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => handleBuyNow(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7165D6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Buy Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrderConfirmationScreen extends StatefulWidget {
  final String productName;

  const OrderConfirmationScreen({Key? key, required this.productName})
      : super(key: key);

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7165D6), Color(0xFFB695F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.greenAccent[400],
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Order Placed!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Your order for",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    Text(
                      widget.productName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "is successfully placed.",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Payment method:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Cash on Delivery",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700]),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A148C),
                        padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Go back to product screen (pop this page)
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back to Products",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
