import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
class EmployeeCard extends StatefulWidget {
  final String? employeeName;
  final String? employeePosition;
  final String? employeeID;
  final String? avatarUrl;
  final String? designation;
  final String? salary;
  final String? type;
  final String? dateofJoining;

  const EmployeeCard({
    super.key,
    required this.employeeName,
    this.employeePosition,
    this.employeeID,
    this.avatarUrl,
    this.designation,
    this.salary,
    this.type,
    this.dateofJoining,
  });
  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  late File _image;
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow.shade700,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 400,
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
               fetchImageFromApi("https://apis.siddhios.com/uploadImg");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          )
                        : const Icon(Icons.person_3_outlined),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.employeeName ?? '',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ID: ${widget.employeeID ?? ''}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'TYPE: ${widget.type}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.designation ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'DOJ - ${widget.dateofJoining}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'DOJ: ${widget.dateofJoining}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SALARY: ₹ ${widget.salary}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  ),
                ], 
              ),
            ),
          ],
        ),
      ),
    );
  }

 // Method to fetch the image from an API
Future<Uint8List?> fetchImageFromApi(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Failed to load image');
      return null;
    }
  } catch (e) {
    print('Error fetching image: $e');
    return null;
  }
}
}
