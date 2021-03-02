import 'dart:io';

import 'package:azula_app/utils/theming.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theming.returnColorDarker(brightness),
        brightness: Theming.statusBarColor(brightness, forDark: true),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Scan QR code',style: TextStyle(color: Theming.returnTextColor(brightness)),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Theming.returnTextColor(brightness),size: 15,),
        ),
      ),
    backgroundColor: Theming.returnColor(brightness),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                Center(
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.redAccent,width: 5)
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
                  : Text('Simply place QR code within camera',style: TextStyle(fontSize:20,color: Theming.returnTextColor(brightness)),),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
      this.controller.dispose();
      Navigator.pop(context,scanData);
    });
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }
}