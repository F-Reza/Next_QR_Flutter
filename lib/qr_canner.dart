import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerPage extends StatefulWidget {
  static const String routeName = '/scanner';
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }


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
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderWidth: 10,
                  borderRadius: 10,
                  borderLength: 20,
                  borderColor: Theme.of(context).canvasColor,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                height: 100,
                child: Center(
                  child: (result != null)
                      ? Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                          'Output: ${result!.code}'),
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

  void _onQRViewCreated(QRViewController controller) {

    //setState(() => this.controller = controller);

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
