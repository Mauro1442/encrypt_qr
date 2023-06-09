import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../encryption/aes.dart';

class CodeScanner extends StatefulWidget {
  const CodeScanner({Key? key}) : super(key: key);

  @override
  State<CodeScanner> createState() => _CodeScannerState();
}

String qrData = "No data found!";

bool hasData = false;

class _CodeScannerState extends State<CodeScanner> {
  AESEncryption encryption = AESEncryption();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Scan QR",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Read Message"),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    qrData,
                    textAlign: TextAlign.center,),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: ((MediaQuery.of(context).size.width) / 2) - 45,
                height: 35,
                child: ElevatedButton(
                  child: const Text(
                    "Scan QR",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () async {
                    var data = await FlutterBarcodeScanner.scanBarcode(
                        "#00FFFFFF", "Cancel", false, ScanMode.QR);
                    setState(() {
                      qrData = data.toString();
                      hasData = true;
                      qrData = encryption
                          .decryptMsg(encryption.getCode(qrData))
                          .toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}