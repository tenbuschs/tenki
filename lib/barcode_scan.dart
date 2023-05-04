import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'off_database_interface.dart' as off;


class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  late Future<CameraController> _controllerFuture;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializeCamera();
  }

  Future<CameraController> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      final controller = CameraController(cameras![0], ResolutionPreset.medium);
      await controller.initialize();
      return controller;
    } else {
      return Future.error('No cameras found');
    }
  }

  @override
  void dispose() {
    _controllerFuture.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    // Call Open Food Facts Database API with barcode
    String productInfo = await off.ProductService.getProduct(barcode);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: FutureBuilder<CameraController>(
        future: _controllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            final controller = snapshot.data!;
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                ),
                ElevatedButton(
                  child: Text('Scan Barcode'),
                  onPressed: _scanBarcode,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
