import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';  // Untuk path gambar
import 'dart:io';  // Untuk File

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Membuat dan menginisialisasi CameraController
    _controller = CameraController(
      widget.camera,           // Mendapatkan kamera yang diinginkan
      ResolutionPreset.medium,  // Menentukan resolusi
    );

    // Inisialisasi controller yang mengembalikan Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil gambar
Future<void> _takePicture() async {
  try {
    // Pastikan kamera sudah siap
    await _initializeControllerFuture;

    // Ambil gambar dan simpan di path sementara
    final image = await _controller.takePicture();

    // Pastikan widget masih terpasang
    if (!mounted) return;  // Ini memeriksa apakah widget masih ada di tree widget

    // Navigasi ke layar yang menampilkan gambar
    await Navigator.of(context as BuildContext).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          imagePath: image.path,  // Path gambar yang diambil
        ),
      ),
    );
  } catch (e) {
    // Menangani error jika ada masalah saat mengambil gambar
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Jika kamera siap, tampilkan pratinjau kamera
            return CameraPreview(_controller);
          } else {
            // Jika kamera belum siap, tampilkan indikator loading
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,  // Panggil fungsi untuk mengambil gambar
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(
        child: Image.file(File(imagePath)),  // Menampilkan gambar
      ),
    );
  }
}
