import '../encryption/aes.dart';
import 'qr_code.dart';
import 'package:flutter/material.dart';


class CodeGenerator extends StatefulWidget {
  const CodeGenerator({Key? key}) : super(key: key);

  @override
  State<CodeGenerator> createState() => _CodeGeneratorState();
}

TextEditingController controller = TextEditingController();

class _CodeGeneratorState extends State<CodeGenerator> {
  AESEncryption encryption = AESEncryption();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Message"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTextFormField(),
          qrGeneratorButton(),
        ],
      ),
    );
  }

  Widget buildTextFormField() => Padding(
    padding: const EdgeInsets.all(15),
    child: TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        labelText: "Write message to encrypt and generate QR",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        prefixIcon: Icon(
          Icons.edit,
        ),
      ),
      onEditingComplete: navigate,
    ),
  );

  Widget qrGeneratorButton() => SizedBox(
    width: ((MediaQuery.of(context).size.width) / 2) - 45,
    height: 35,
    child: ElevatedButton(
      onPressed: navigate,
      child: const Text(
        "Generate QR",
      ),
    ),
  );

  void navigate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GeneratedQrCode(encryption.encryptMsg(controller.text).base16),),);
  }
}