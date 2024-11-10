import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:next_qrx/service_provider.dart';

class ScanFromGalleryScreen extends StatefulWidget {
  static const String routeName = '/scan_from_gallery';

  const ScanFromGalleryScreen({super.key});
  @override
  _ScanFromGalleryScreenState createState() => _ScanFromGalleryScreenState();
}

class _ScanFromGalleryScreenState extends State<ScanFromGalleryScreen> {
  final ServiceProvider provider = ServiceProvider();
  String? _scannedEmail;

  String _message = "Select an image to scan for a QR code.";
  final ImagePicker _picker = ImagePicker();
  final BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  Future<void> _scanQrCodeFromGallery() async {

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      final List<Barcode> getBarcodes = await _barcodeScanner.processImage(inputImage);
      for (final getEmail in getBarcodes) {
        setState(() {
          _scannedEmail = getEmail.rawValue;
        });

        //print("========BarCode: ${getEmail.rawValue} ================");
        if (getEmail.rawValue != null && _isValidEmail(getEmail.rawValue!)) {
          provider.mailContact(getEmail.rawValue!);
        }
      }

      setState(() {
        _message = barcodes.isNotEmpty ? "ok found -> $_scannedEmail" : "Email address not found!";
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
          title: const Text('Scan QR Code from Gallery',style: TextStyle(color: Colors.white),),
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

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }


}
