import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../printer/bt_printer.dart';

class GeneratedQrCode extends StatefulWidget {
  final String myQR;

  const GeneratedQrCode(this.myQR, {super.key});

  @override
  State<GeneratedQrCode> createState() => _GeneratedQrCodeState();
}

class _GeneratedQrCodeState extends State<GeneratedQrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encrypted Message QR"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        QrImageView(
          data: widget.myQR,
          version: QrVersions.auto,
          size: 250.0,
          gapless: false,
          backgroundColor: Colors.white,
        ),
            TextButton(onPressed: () => printQr(
              QrImageView(
                data: widget.myQR,
                version: QrVersions.auto,
                size: 250.0,
                gapless: false,
                backgroundColor: Colors.white,
              ).toString().codeUnits,
            ), child: const Text("Print")),
            TextButton(onPressed: () => saveFile(), child: const Text("Save image to file")),
      ]),
    );
  }

  printQr(img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BluetoothPrinter(img),
      ),
    );

  }
///this function saves the qr code to the device
  saveFile() {

  }

}
