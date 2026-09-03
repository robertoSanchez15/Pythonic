import 'package:flutter/material.dart';

/// El "cascarón" del monitor: bisel + cuello + base, 100% widgets
/// nativos. No sabe qué app está abierta — solo recibe `screen`.
class DesktopMonitorFrame extends StatelessWidget {
  final Widget screen;
  final double width;

  static const _bezelColor = Color(0xFF17233D);
  static const _screenRadius = 14.0;
  static const _bezelThickness = 10.0;

  const DesktopMonitorFrame({
    super.key,
    required this.screen,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = width - _bezelThickness * 2;
    final screenHeight = screenWidth * 0.78; // antes 0.68 — más alta

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(_bezelThickness),
          decoration: BoxDecoration(
            color: _bezelColor,
            borderRadius:
                BorderRadius.circular(_screenRadius + _bezelThickness),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_screenRadius),
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: screen,
            ),
          ),
        ),
        Container(width: width * 0.12, height: 26, color: _bezelColor), // antes 14 — cuello más alto
        Container(
          width: width * 0.42,
          height: 16, // antes 10 — base más alta
          decoration: BoxDecoration(
            color: _bezelColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}