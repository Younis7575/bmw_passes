import 'package:bmw_passes/constants/custom_color.dart';
import 'package:bmw_passes/screens/home/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  String? qrResult;
  double zoomValue = 0.0;

  late AnimationController _animController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    // 🔴 Scanning line animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _positionAnimation = Tween<double>(
      begin: -1,
      end: 1,
    ).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80; // wider
    final double boxHeight =
        MediaQuery.of(context).size.height * 0.35; // taller
    const double topOffset = 170; // move down from top

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 📷 Camera Scanner
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

            /// 🌓 Overlay with transparent box
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                CustomColor.screenBackground,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: topOffset),
                      child: Container(
                        width: boxWidth,
                        height: boxHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔵 Blue corners
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: topOffset),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: Stack(
                    children: [
                      _buildCorner(Alignment.topLeft),
                      _buildCorner(Alignment.topRight),
                      _buildCorner(Alignment.bottomLeft),
                      _buildCorner(Alignment.bottomRight),
                    ],
                  ),
                ),
              ),
            ),

            /// 🔴 Animated Red Line
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: topOffset),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: AnimatedBuilder(
                    animation: _positionAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, _positionAnimation.value),
                        child: Container(
                          width: boxWidth,
                          height: 3,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            /// 🔙 Back Button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: CustomColor.mainText,
                  size: 25,
                ),
                onPressed: () => Get.back(),
              ),
            ),

            /// 📏 Zoom Slider + Scan Button (Bottom Section)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 📏 Zoom Slider with - and +
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
                                ),
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

                    // 🔘 Scan Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 364,
                        height: 67,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const UserDetailScreen());
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomColor.mainText,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }

  /// 🔵 Build only blue corner edges
  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Colors.blue, width: 15)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Colors.blue, width: 15)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.blue, width: 15)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.blue, width: 15)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// ✅ Custom thumb with shadow
class ShadowSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const ShadowSliderThumbShape({this.thumbRadius = 8});

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

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, thumbRadius + 2, shadowPaint);

    final thumbPaint = Paint()..color = sliderTheme.thumbColor ?? Colors.red;
    canvas.drawCircle(center, thumbRadius, thumbPaint);
  }
}
