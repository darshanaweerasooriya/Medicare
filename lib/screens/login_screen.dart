import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
//
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passToggle = true;

  Future<void> loginUser() async {
    final url = Uri.parse('http://10.0.2.2:3000/login');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Email': usernameController.text,
          'password': passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        // Save token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', responseData['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
        );

        // Navigate or call secure API
        getUserData(); // Example call
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Check credentials."), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      print('Login error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred."), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final url = Uri.parse('http://10.0.2.2:3000/getuser');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("User Data: $data");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User data retrieved"), backgroundColor: Colors.blue),
      );
    } else {
      print("Failed to fetch user data: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user data"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 50),
            Image.asset("images/login.png", height: 200),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: passToggle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(passToggle ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      passToggle = !passToggle;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7165D6)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Log In", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}