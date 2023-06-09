import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: QrImageView(
            data: widget.myQR,
            version: QrVersions.auto,
            size: 250.0,
            gapless: false,
          ),
        ),
      ),
    );
  }
}