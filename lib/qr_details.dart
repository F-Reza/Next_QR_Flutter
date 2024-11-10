import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class QRDetailsScreen extends StatefulWidget {
  final String name;
  final String email;
  final String qrData;


  const QRDetailsScreen({
    super.key,
    required this.name,
    required this.email,
    required this.qrData,
  });

  @override
  _QRDetailsScreenState createState() => _QRDetailsScreenState();
}

class _QRDetailsScreenState extends State<QRDetailsScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  // Capture the screen and save it to the gallery
  Future<void> captureAndSaveImage(BuildContext context) async {
    // Request permission to access the storage using photo_manager
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final Uint8List? uint8list = await screenshotController.capture();

      if (uint8list != null) {
        try {
          // Get the temporary directory of the device
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/qr_code.png';

          // Save the screenshot as an image file
          final file = File(imagePath)..writeAsBytesSync(uint8list);

          // Using photo_manager to save to gallery
          final asset = await PhotoManager.editor.saveImage(
            file.readAsBytesSync(),
            filename: 'qr_code.png',  // Added filename correctly here
          );
          if (asset != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code saved to gallery!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save the QR Code.')),
            );
          }
        } catch (e) {
          // Handle any errors that occur during the process
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error capturing or saving image.')),
          );
        }
      }
    } else {
      // If permission is not granted, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied. Unable to save image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF561B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'QR Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
            onPressed: () {
              captureAndSaveImage(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "QR Code",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: MediaQuery.sizeOf(context).width / 1.5,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1), // Shadow color
                                      spreadRadius: 2, // How much the shadow spreads
                                      blurRadius: 6, // How blurry the shadow is
                                      offset: const Offset(0, 4), // Shadow position (x, y)
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: QrImageView(
                                      data: widget.qrData,
                                      version: QrVersions.auto,
                                      size: 210,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        const Text("Name:",style: TextStyle(color: Colors.deepOrange,fontSize: 18),),
                        const SizedBox(height: 8),
                        Text(widget.name, style: Theme.of(context).textTheme.titleMedium,),
                        const SizedBox(height: 20),
                        const Text("Email Address:",style: TextStyle(color: Colors.deepOrange,fontSize: 18),),
                        const SizedBox(height: 8),
                        Text(widget.email, style: Theme.of(context).textTheme.titleMedium,),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
