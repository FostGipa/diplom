import 'package:app/features/common/controllers/qr_scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatelessWidget {
  final String? idTask;
  QRScanScreen({super.key, this.idTask});

  final MobileScannerController controller = MobileScannerController();
  final QrScannerController _controller = Get.put(QrScannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканируйте QR-код')),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code == idTask) {
              _controller.endTask(idTask!);
            }
          }
        },
      ),
    );
  }
}
