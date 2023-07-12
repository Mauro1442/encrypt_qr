import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPrinter extends StatefulWidget {
  final String printedText;

  const BluetoothPrinter(this.printedText, {super.key});

  @override
  BluetoothPrinterState createState() => BluetoothPrinterState();
}

class BluetoothPrinterState extends State<BluetoothPrinter> {
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  bool isConnecting = false;
  bool isScanning = false;

  late String printedText = '''
                            ${widget.printedText}
                            
                            
                            
                            \n
                            ''';

  @override
  void initState() {
    super.initState();
    _getBondedDevices();
  }

  Future<void> _getBondedDevices() async {
    final bondedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devices = bondedDevices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
    });

    BluetoothConnection.toAddress(device.address)
        .then((BluetoothConnection connection) {
      print('Connected to the device');
      setState(() {
        this.connection = connection;
        isConnecting = false;
      });
    }).catchError((error) {
      print('Cannot connect, error: $error');
    });
  }

  Future<void> _startDiscovery() async {
    setState(() {
      devices = [];
      isScanning = true;
    });

    final Set<String> uniqueAddresses = Set<String>();

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (uniqueAddresses.contains(r.device.address)) {
        return;
      }

      setState(() {
        devices.add(r.device);
        uniqueAddresses.add(r.device.address);
      });
    }).onDone(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  void _printText() {
    if (connection != null) {
      final data = utf8.encode(printedText);
      final uint8List = Uint8List.fromList(data);
      connection!.output.add(uint8List);
      connection!.output.allSent.then((_) {
        print('Printed');
      });
    }
  }

  /*
  *
  * */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Printer'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = devices[index];
                  return ListTile(
                    title: Text(device.name ?? 'Unknown Device'),
                    subtitle: Text(device.address),
                    onTap: () {
                      _connectToDevice(device);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: isScanning ? null : _startDiscovery,
              child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _printText,
          child: Icon(Icons.print),
        ),
      ),
    );
  }
}
