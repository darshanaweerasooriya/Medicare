import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class Doctor {
  final String name;
  final String contactNumber;
  final String specializedArea;
  final String? imageBase64;

  Doctor({
    required this.name,
    required this.contactNumber,
    required this.specializedArea,
    this.imageBase64,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      contactNumber: json['contactnumber'],
      specializedArea: json['specializedArea'],
      imageBase64: json['image']?['data'], // base64 string expected
    );
  }
}

class Doctors extends StatefulWidget {
  final String hospitalName;
  const Doctors({super.key, required this.hospitalName});

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  String searchQuery = '';
  String? selectedSpecialization;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/seachdoc"),
      );

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        List<Doctor> allDoctors = jsonData.map((e) => Doctor.fromJson(e)).toList();

        // Filter based on hospitalName (mocked logic for now)
        List<Doctor> hospitalDoctors = allDoctors.where((doc) {
          if (widget.hospitalName == 'Kandy General Hospital') {
            return doc.name.toLowerCase().contains('athukorala') || doc.name.toLowerCase().contains('silva');
          } else if (widget.hospitalName == 'Colombo National Hospital') {
            return doc.name.toLowerCase().contains('perera') || doc.name.toLowerCase().contains('fernando');
          }
          return false;
        }).toList();

        setState(() {
          doctors = hospitalDoctors;
          filteredDoctors = List.from(hospitalDoctors);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterDoctors() {
    List<Doctor> temp = List.from(doctors);

    if (searchQuery.isNotEmpty) {
      temp = temp
          .where((doc) =>
      doc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doc.specializedArea.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedSpecialization != null && selectedSpecialization != 'All') {
      temp = temp
          .where((doc) =>
      doc.specializedArea.toLowerCase() ==
          selectedSpecialization!.toLowerCase())
          .toList();
    }

    setState(() {
      filteredDoctors = temp;
    });
  }

  void _showFilterDialog() {
    final specializations = <String>{
      'All',
      ...doctors.map((d) => d.specializedArea).toSet(),
    }.toList();

    String? tempSelected = selectedSpecialization ?? 'All';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by Specialization'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: specializations.length,
                itemBuilder: (context, index) {
                  final spec = specializations[index];
                  return RadioListTile<String>(
                    title: Text(spec),
                    value: spec,
                    groupValue: tempSelected,
                    onChanged: (value) {
                      setStateDialog(() {
                        tempSelected = value;
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedSpecialization =
                tempSelected == 'All' ? null : tempSelected;
              });
              _filterDoctors();
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors at ${widget.hospitalName}'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Doctors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                _filterDoctors();
              },
            ),
          ),
          Expanded(
            child: filteredDoctors.isEmpty
                ? Center(child: Text('No doctors found'))
                : GridView.builder(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                Uint8List? imageData;

                if (doctor.imageBase64 != null) {
                  imageData =
                      base64Decode(doctor.imageBase64!);
                }

                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                        imageData != null
                            ? MemoryImage(imageData)
                            : AssetImage("assets/images/default_doc.png")
                        as ImageProvider,
                      ),
                      SizedBox(height: 8),
                      Text(
                        doctor.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        doctor.specializedArea,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          Text(
                            "4.9",
                            style:
                            TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}