import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/screens/home/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  String? qrResult;
  double zoomValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: CustomColor.mainText,
                  size: 25,
                ),
                onPressed: () => Get.back(),
              ),
            ),

            // 📷 QR Scanner
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        setState(() {
                          qrResult = barcode.rawValue;
                        });
                      }
                    },
                  ),

                  // 🔴 Red scanning line
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.23,
                    child: Container(width: 220, height: 2, color: Colors.red),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📏 Zoom Slider with - and + icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.remove, color: CustomColor.slider),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const ShadowSliderThumbShape(
                          thumbRadius: 6,
                        ), // 👈 chota dot
                      ),
                      child: Slider(
                        value: zoomValue,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.red,
                        onChanged: (val) async {
                          setState(() => zoomValue = val);
                          await controller.setZoomScale(val);
                        },
                      ),
                    ),
                  ),
                  const Icon(Icons.add, color: CustomColor.slider),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Scan Button (Image Only)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 364,
                height: 67,
                child: GestureDetector(
                  onTap: () {
                    // 👇 Yahan apni next screen ka navigation lagao
                    Get.to(() => const ProfileScreen());
                    // agar GetX use nahi kar rahe to:
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const NextScreen()));
                  },
                  child: Stack(
                    clipBehavior: Clip.none, // 👈 allow overflow
                    children: [
                      // background container
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColor.mainText,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // 👇 image jo container ke upar overlap karegi
                      Positioned(
                        left: 120,
                        top: -40,
                        child: Image.asset(
                          "assets/images/QR.1.png",
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Custom thumb with shadow
class ShadowSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const ShadowSliderThumbShape({this.thumbRadius = 8}); // 👈 default chota

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // 👇 Shadow paint
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

    // 👇 Main thumb paint
    final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
    canvas.drawCircle(center, thumbRadius, thumbPaint);
  }
}
