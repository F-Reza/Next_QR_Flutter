
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:next_qrx/service_provider.dart';

class QrScannerPage extends StatefulWidget {
  static const String routeName = '/scanner';
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final ServiceProvider provider = ServiceProvider();
  String? _scannedEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const MainDrawer(),
      backgroundColor: const Color(0xFFFF561B),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF561B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Easy QR Scanner',style: TextStyle(color: Colors.white,)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: MobileScanner(fit: BoxFit.cover,
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  returnImage: false,
                ),
                onDetect: (capture) {
                  final List<Barcode> getBarcodes = capture.barcodes;

                  for (final getEmail in getBarcodes) {
                    setState(() {
                      _scannedEmail = getEmail.rawValue;
                    });

                    //print("========BarCode: ${getEmail.rawValue} ================");
                    if (getEmail.rawValue != null && _isValidEmail(getEmail.rawValue!)) {
                      provider.mailContact(getEmail.rawValue!);
                    }
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                height: 100,
                child: Center(
                  child: (_scannedEmail != null)
                      ? Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: Colors.white,
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Output: $_scannedEmail'),
                    ),
                  )
                      : Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.9,
                    color: Colors.white38,
                    child: const Text('Scan Now', style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 26),),
                  ),
                ),
              ),
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
