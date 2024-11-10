import 'package:flutter/material.dart';
import 'package:next_qrx/qr_canner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'qr_list.dart';
import 'scan_from_gallery.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  String email = '';
  String name = '';
  List<Map<String, String>> saveQRList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF561B),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF561B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('QR X',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, ScanFromGalleryScreen.routeName),
            icon: const Icon(Icons.qr_code_sharp),
          ),

          IconButton(
              onPressed: () => Navigator.pushNamed(context, QRListScreen.routeName),
              icon: const Icon(Icons.list_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15,),
              //_buildGalleryScanner(),
              const SizedBox(height: 25,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, QrScannerPage.routeName);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(4, 4),
                            blurRadius: 15,
                            spreadRadius: 1
                        ),
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(-4, -4),
                            blurRadius: 15,
                            spreadRadius: 1
                        ),
                      ]
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_scanner,size: 55,color: Colors.deepOrange,),
                      SizedBox(height: 5,),
                      Text("Scanner", style: TextStyle(color: Colors.deepOrange,fontSize: 16),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              const Divider(height: 3,color: Colors.white,),
              const SizedBox(height: 20,),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("--------QR Generator-----", style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
              const SizedBox(height: 10,),
              if (name.isEmpty || email.isEmpty)
                Container(
                  height: 210,
                  width: 210,
                  color: Colors.white,
                ),
              if (name.isNotEmpty && email.isNotEmpty) _buildQRCode(),
              const SizedBox(height: 30,),
              _buildNameTextField(),
              const SizedBox(height: 10,),
              _buildEmailTextField(),
              const SizedBox(height: 20,),
              if (email.isNotEmpty) _buildSaveButton(),
              const SizedBox(height: 60,),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // Save the QR code data to SharedPreferences
  _saveQR(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    saveQRList.add({'name': name, 'email': email});
    List<String> stringList = saveQRList
        .map((item) => '${item['name']},${item['email']}')
        .toList();
    await prefs.setStringList('xQRCodes', stringList);
    setState(() {});
  }

  // Build the name input field
  Widget _buildNameTextField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width -60,
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: true,
          contentPadding: EdgeInsets.only(
              left: 14.0, top: 14.0),
          fillColor: Colors.white70,
          hintText: 'Enter your Name..',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.person_outline,
              color: Colors.deepOrange,
              size: 26,
            ),
          ),
        ),
        onChanged: (text) {
          setState(() {
            name = text;
          });
        },
      ),
    );
  }
  // Build the email input field
  Widget _buildEmailTextField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width -60,
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: true,
          contentPadding: EdgeInsets.only(
              left: 14.0, top: 14.0),
          fillColor: Colors.white70,
          hintText: 'Enter your email..',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.email_outlined,
              color: Colors.deepOrange,
              size: 26,
            ),
          ),
        ),
        onChanged: (text) {
          setState(() {
            email = text;
          });
        },
      ),
    );
  }
  // Build the generated QR code
  Widget _buildQRCode() {
    return QrImageView(
      //data: controller.text,
      data: email,
      version: QrVersions.auto,
      size: 210,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
    );
  }

  // Build the button to save the QR code
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        _saveQR(name, email);
        emailController.clear();
        nameController.clear();
        setState(() {
          email = emailController.text;
          name = nameController.text;
        });
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message:
            "QR Code Saved to List",
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: 160,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1
              ),
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1
              ),
            ]
        ),
        child: const Text(
          'Save QR Code',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }


}
