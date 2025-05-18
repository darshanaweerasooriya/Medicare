import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http
;

import 'docScreen.dart';
import 'Hospital.dart';

class nearby extends StatefulWidget {
  const nearby({super.key});

  @override
  State<nearby> createState() => _nearbyState();
}

class _nearbyState extends State<nearby> {
  List<Hospital> nearbyHospitals = [];
  List<Marker> hospitalMarkers = [];

  // Replace this with your backend URL that returns nearby hospitals after tally
  final String apiUrl = 'http://10.0.2.2:3000/nearby';

  @override
  void initState() {
    super.initState();
    @override
    void initState() {
      super.initState();

      // Hardcoded Kandy Hospital for demonstration
      Hospital kandyHospital = Hospital(
        name: 'Kandy General Hospital',
        latitude: 7.2906,
        longitude: 80.6337,
      );

      setState(() {
        nearbyHospitals = [kandyHospital];
        hospitalMarkers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(kandyHospital.latitude, kandyHospital.longitude),
            child: const Icon(Icons.local_hospital, color: Colors.red, size: 30),
          ),
        ];
      });

      // Optionally fetch real hospitals afterward
      fetchNearbyHospitals();
    }

    fetchNearbyHospitals();
  }

  Future<void> fetchNearbyHospitals() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Hospital> hospitals = data.map((json) => Hospital.fromJson(json)).toList();

        setState(() {
          nearbyHospitals = hospitals;
          hospitalMarkers = hospitals.map((hospital) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(hospital.latitude, hospital.longitude),
              child: const Icon(Icons.local_hospital, color: Colors.red, size: 30),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load nearby hospitals');
      }
    } catch (e) {
      print(e);
      // You can show error dialog/snackbar here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Hospitals')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: nearbyHospitals.length,
              itemBuilder: (context, index) {
                final hospital = nearbyHospitals[index];
                return ListTile(
                  leading: Icon(Icons.local_hospital, color: Colors.red),
                  title: Text(hospital.name),
                  subtitle: Text('Lat: ${hospital.latitude.toStringAsFixed(4)}, Lon: ${hospital.longitude.toStringAsFixed(4)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Doctors(hospitalName: hospital.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: nearbyHospitals.isNotEmpty
                    ? LatLng(nearbyHospitals[0].latitude, nearbyHospitals[0].longitude)
                    : LatLng(7.8731, 80.7718), // default center if list empty
                initialZoom: 7.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: hospitalMarkers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}