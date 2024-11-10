import 'package:flutter/material.dart';
import 'package:next_qrx/qr_canner.dart';

import 'home_screen.dart';
//0xFFFF561B

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (_) => const HomePage(),
        QrScannerPage.routeName : (_) => const QrScannerPage(),
      },
    );
  }
}
