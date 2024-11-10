import 'package:flutter/material.dart';
import 'package:next_qrx/qr_canner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              onPressed: () {
                //
              },
              icon: const Icon(Icons.copy_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, QrScannerPage.routeName);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 60,
                  height: 70,
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_scanner,size: 55,color: Colors.deepOrange,),
                      SizedBox(width: 10,),
                      Text("Scan From Gallery", style: TextStyle(color: Colors.deepOrange,fontSize: 18),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, QrScannerPage.routeName);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                      SizedBox(height: 10,),
                      Text("Scanner", style: TextStyle(color: Colors.deepOrange,fontSize: 18),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              const Divider(height: 3,color: Colors.white,),
              const SizedBox(height: 20,),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("-----------QR Generator--------", style: TextStyle(color: Colors.white,fontSize: 18),),
                ],
              ),
              const SizedBox(height: 10,),
              QrImageView(
                //data: controller.text,
                data: 'mailto:${controller.text}',
                version: QrVersions.auto,
                size: 240.0,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(40),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width -60,
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, top: 14.0),
                    fillColor: Colors.white70,
                    hintText: 'Enter your text..',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 4,
                      ),
                    ),
                    suffixIcon: TextButton(
                      onPressed: () => setState((){}),
                      child: Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: const Text('GET',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
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
                child: TextButton(onPressed: () {
                  //
                },
                  child: const Text('Export',style: TextStyle(color: Colors.deepOrange),),
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
}
