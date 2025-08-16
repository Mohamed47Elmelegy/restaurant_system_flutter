import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import 'table_info_page.dart';

class QrScannerPage extends StatefulWidget {
  final CartEntity cart;
  const QrScannerPage({super.key, required this.cart});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String? extractTableId(String qr) {
    final match = RegExp(r'TABLE_(\d+)_').firstMatch(qr);
    if (match != null) {
      return match.group(1);
    }
    if (RegExp(r'^\d+ ').hasMatch(qr)) {
      return qr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Table QR')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type:  [32m${describeEnum(result!.format)}   Data: ${result!.code}',
                    )
                  : const Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null) {
        setState(() {
          result = scanData;
        });
        final qrString = scanData.code ?? '';
        controller.pauseCamera();
        // Instead of pop, navigate to TableInfoPage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => TableInfoPage(qrCode: qrString, cart: widget.cart),
          ),
        );
      }
    });
  }
}
