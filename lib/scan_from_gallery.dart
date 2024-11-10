import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScanFromGalleryScreen extends StatefulWidget {
  static const String routeName = '/scan_from_gallery';

  const ScanFromGalleryScreen({super.key});
  @override
  _ScanFromGalleryScreenState createState() => _ScanFromGalleryScreenState();
}

class _ScanFromGalleryScreenState extends State<ScanFromGalleryScreen> {
  String _message = "Select an image to scan for a QR code.";
  final ImagePicker _picker = ImagePicker();
  final BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  Future<void> _scanQrCodeFromGallery() async {

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      setState(() {
        _message = barcodes.isNotEmpty ? "ok found" : "not found";
      });
    } else {
      setState(() {
        _message = "No image selected.";
      });
    }
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF561B),
        iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Scan QR Code from Gallery"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanQrCodeFromGallery,
              child: const Text("Select Image from Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
