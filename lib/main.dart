import 'package:flutter/material.dart';
import 'package:next_qrx/qr_canner.dart';
import 'package:next_qrx/service_provider.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'qr_details.dart';
import 'qr_list.dart';
import 'scan_from_gallery.dart';
//0xFFFF561B

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ServiceProvider>(
      create: (context) => ServiceProvider(),
      child: MaterialApp(
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
          QRListScreen.routeName : (_) => const QRListScreen(),
          ScanFromGalleryScreen.routeName : (_) =>  ScanFromGalleryScreen(),
        },
      ),
    );
  }
}



/*
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
        QRListScreen.routeName : (_) => const QRListScreen(),
      },
    );
  }
}
*/
