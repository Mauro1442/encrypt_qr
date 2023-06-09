import 'package:flutter/material.dart';

import '../encryption/aes.dart';
import '../qr_generator/generator.dart';
import '../qr_scanner/scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AESEncryption encryption = AESEncryption();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encrypt / Decrypt QR"),
      ),
      body: SizedBox(
        height: (MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: (MediaQuery.of(context).size.height) - AppBar().preferredSize.height - kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Send and Receive Encrypted Messages",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    codeScannerButton(context),
                    const SizedBox(
                      width: 25,
                    ),
                    codeGeneratorButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget codeScannerButton(BuildContext context) => ElevatedButton(
  child: const Text(
    "Read Message",
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CodeScanner(),
      ),
    );
  },
);

Widget codeGeneratorButton(BuildContext context) => ElevatedButton(
  child: const Text(
    "Send Message",
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CodeGenerator(),
      ),
    );
  },
);
