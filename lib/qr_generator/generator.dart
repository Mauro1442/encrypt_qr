import '../encryption/aes.dart';
import 'qr_code.dart';
import 'package:flutter/material.dart';
import '../printer/bt_printer.dart';


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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextFormField(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: qrGeneratorButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: qrPrinterButton(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: btButton(),
          ),

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
      onEditingComplete: qrView,
    ),
  );

  Widget qrGeneratorButton() => SizedBox(
    width: ((MediaQuery.of(context).size.width) / 2) - 45,
    height: 35,
    child: ElevatedButton(
      onPressed: qrView,
      child: const Text(
        "Generate QR",
      ),
    ),
  );

  Widget qrPrinterButton() => SizedBox(
    width: ((MediaQuery.of(context).size.width) / 2) - 45,
    height: 35,
    child: ElevatedButton(
      onPressed: (){},//printText,
      child: const Text(
        "Print Text",
      ),
    ),
  );

  Widget btButton() => SizedBox(
    width: ((MediaQuery.of(context).size.width) / 2) - 45,
    height: 35,
    child: ElevatedButton(
      onPressed: printEncryptedText,
      child: const Text(
        "Print encrypted",
      ),
    ),
  );

  void qrView() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GeneratedQrCode(encryption.encryptMsg(controller.text).base16),),);
  }

  // void printText() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               BluetoothPrinter(controller.text,),),);
  // }

  void printEncryptedText() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BluetoothPrinter(encryption.encryptMsg(controller.text).base16),),);
  }

  void printQrCode() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BluetoothPrinter(encryption.encryptMsg(controller.text).base16),),);
  }
}