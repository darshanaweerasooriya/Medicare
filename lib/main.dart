import 'package:flutter/material.dart';
import 'package:medicare/screens/Orders.dart';
import 'package:medicare/screens/Viewproducts.dart';
import 'package:medicare/screens/addmedicine.dart';
import 'package:medicare/screens/appointment_screen.dart';
import 'package:medicare/screens/booking.dart';
import 'package:medicare/screens/docScreen.dart';
import 'package:medicare/screens/nearbyHospitals.dart';
import 'package:medicare/screens/parmacySignup.dart';
import 'package:medicare/screens/pharmacist_chatList.dart';
import 'package:medicare/screens/welcome_screen.dart';
import 'package:medicare/widgets/navbar_roots.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: nearby()
    );
  }
}