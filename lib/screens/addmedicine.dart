// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class Addmedicine extends StatefulWidget {
//   const Addmedicine({super.key});
//
//   @override
//   State<Addmedicine> createState() => _AddmedicineState();
// }
//
// class _AddmedicineState extends State<Addmedicine> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController brandController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   bool isLoading = false;
//
//   Future<void> _pickImage() async {
//     final pickedFile =
//     await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     // Convert image file to base64 string (if image selected)
//     String? base64Image;
//     String? imageType;
//
//     if (_imageFile != null) {
//       final bytes = await _imageFile!.readAsBytes();
//       base64Image = base64Encode(bytes);
//       imageType = _imageFile!.path.split('.').last; // get file extension
//     }
//
//     final url = Uri.parse('http://YOUR_BACKEND_URL/api/products'); // Change URL
//
//     final body = {
//       "productname": productNameController.text.trim(),
//       "brand": brandController.text.trim(),
//       "price": priceController.text.trim(),
//       "description": descriptionController.text.trim(),
//       if (base64Image != null)
//         "image": {
//           "data": base64Image,
//           "contentType": "image/$imageType",
//         },
//     };
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Product added successfully')),
//         );
//         _formKey.currentState!.reset();
//         setState(() {
//           _imageFile = null;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add product')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Medicine')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: productNameController,
//                   decoration: const InputDecoration(labelText: 'Product Name'),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter product name' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: brandController,
//                   decoration: const InputDecoration(labelText: 'Brand'),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter brand' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: priceController,
//                   decoration: const InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter price' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   maxLines: 3,
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter description' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 _imageFile != null
//                     ? Image.file(_imageFile!, height: 150)
//                     : const Text('No image selected'),
//                 TextButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.image),
//                   label: const Text('Pick Image'),
//                 ),
//                 const SizedBox(height: 20),
//                 isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: _submitForm,
//                   child: const Text('Add Product'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }