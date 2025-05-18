import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class bookin extends StatefulWidget {
  const bookin({super.key});

  @override
  State<bookin> createState() => _bookinState();
}

class _bookinState extends State<bookin> {
  final _emailController = TextEditingController();
  final _doctorIdController = TextEditingController();
  final _bookingNumberController = TextEditingController();

  DateTime? _bookingDate;
  bool isSubmitting = false;

  Future<void> _pickBookingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _bookingDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_doctorIdController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _bookingNumberController.text.isEmpty ||
        _bookingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final url = Uri.parse('http://10.0.2.2:3000/booking');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'doctorId': _doctorIdController.text.trim(),
        'patientEmail': _emailController.text.trim(),
        'bookingNumber': _bookingNumberController.text.trim(),
        'bookingDate': _bookingDate!.toIso8601String().split('T')[0],
      }),
    );

    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          TextField(
            controller: _doctorIdController,
            decoration: InputDecoration(labelText: 'Doctor ID', border: OutlineInputBorder()),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Patient Email', border: OutlineInputBorder()),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _bookingNumberController,
            decoration: InputDecoration(labelText: 'Booking Number', border: OutlineInputBorder()),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(
              _bookingDate == null
                  ? 'Pick Booking Date'
                  : 'Date: ${_bookingDate!.toLocal()}'.split(' ')[0],
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: _pickBookingDate,
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            icon: isSubmitting
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Icon(Icons.send),
            label: Text(isSubmitting ? 'Submitting...' : 'Confirm Booking'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: EdgeInsets.all(16)),
            onPressed: isSubmitting ? null : _submitBooking,
          ),
        ]),
      ),
    );
  }
}