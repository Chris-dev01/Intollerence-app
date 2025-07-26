// lib/pages/scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatelessWidget {
  final Function(String) onCodeScanned;

  const ScannerPage({super.key, required this.onCodeScanned});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            facing: CameraFacing.back,
            torchEnabled: false,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? code = barcode.rawValue;
              if (code != null) {
                onCodeScanned(code);
                break;
              }
            }
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Scannez un code-barres",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
