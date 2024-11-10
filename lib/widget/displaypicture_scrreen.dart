import 'dart:io';  // Import untuk File
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture - NIM Anda')),
      body: Center(
        // Pastikan File yang diberikan valid
        child: imagePath.isNotEmpty ? Image.file(File(imagePath)) : const Text("No image to display"),
      ),
    );
  }
}
