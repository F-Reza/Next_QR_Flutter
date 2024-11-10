import 'package:flutter/material.dart';
import 'package:next_qrx/qr_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRListScreen extends StatefulWidget {
  static const String routeName = '/qr_list';
  const QRListScreen({super.key});

  @override
  _QRListScreenState createState() => _QRListScreenState();
}

class _QRListScreenState extends State<QRListScreen> {
  List<Map<String, String>> saveQRList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedQRs();
  }

  // Load saved QR codes from SharedPreferences
  _loadSavedQRs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('xQRCodes');
    if (savedList != null) {
      setState(() {
        saveQRList = savedList
            .map((item) => Map<String, String>.from({
          'name': item.split(',')[0],
          'email': item.split(',')[1],
        }))
            .toList()
            .reversed
            .toList(); // Reverse the list
      });
    }
  }

  _deleteQR(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('xQRCodes');
    if (savedList != null) {
      savedList.removeAt(index);
      await prefs.setStringList('xQRCodes', savedList);
    }
    setState(() {
      saveQRList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF561B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'All QR Code',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: saveQRList.isEmpty
          ? const Center(child: Text('No QR Codes saved yet!'))
          : ListView.builder(
        itemCount: saveQRList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(saveQRList[index]['name'] ?? 'Unnamed'),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteQR(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code deleted')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 6.0, horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRDetailsScreen(
                        name: saveQRList[index]['name'] ?? 'Unnamed',
                        email: saveQRList[index]['email'] ?? 'No Email',
                        qrData: saveQRList[index]['email'] ?? 'Unnamed',
                      ),
                    ),
                  );
                },
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.qr_code,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                saveQRList[index]['name'] ?? 'Unnamed',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Text(
                                    'Email: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      saveQRList[index]['email'] ??
                                          'No Email',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _deleteQR(index);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
