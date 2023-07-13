import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPrinter extends StatefulWidget {

  const BluetoothPrinter(this.qrImage, {super.key});

  final List<int> qrImage;


  @override
  State<BluetoothPrinter> createState() => _BluetoothPrinterState();
}

class _BluetoothPrinterState extends State<BluetoothPrinter> {
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  bool isConnecting = false;
  bool isScanning = false;

  // late String printedText = '''
  //                           ${widget.printedText}
  //
  //
  //
  //                           \n
  //                           ''';

  @override
  void initState() {
    super.initState();
    _getBondedDevices();
  }

  Future<void> _getBondedDevices() async {
    final bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devices = bondedDevices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
    });

    BluetoothConnection.toAddress(device.address).then((BluetoothConnection connection) {
      if (kDebugMode) {
        print('Connected to the device');
      }
      setState(() {
        this.connection = connection;
        isConnecting = false;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Cannot connect, error: $error');
      }
    });
  }

  Future<void> _startDiscovery() async {
    setState(() {
      devices = [];
      isScanning = true;
    });

    final Set<String> uniqueAddresses = <String>{};

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

  // void _printText() {
  //   if (connection != null) {
  //     final data = utf8.encode(printedText ?? '');
  //     final uint8List = Uint8List.fromList(data);
  //     connection!.output.add(uint8List);
  //     connection!.output.allSent.then((_) {
  //       if (kDebugMode) {
  //         print('Printed');
  //       }
  //     });
  //   }
  // }

  void _printImage() {
    if (connection != null) {
      final data = Uint8List.fromList(widget.qrImage!);
      final uint8List = Uint8List.fromList(data);
      connection!.output.add(uint8List);
      connection!.output.allSent.then((_) {
        if (kDebugMode) {
          print('Printed');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printer'),
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
        onPressed: () => _printImage(),//_printText,
        child: const Icon(Icons.print),
      ),
    );
  }
}
