import 'package:flutter/material.dart';

class PathConnector extends StatelessWidget {
  final double fromX; // -1..1
  final double toX; // -1..1
  final Color color;

  const PathConnector({
    super.key,
    required this.fromX,
    required this.toX,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConnectorPainter(fromX: fromX, toX: toX, color: color),
      ),
    );
  }
}

class _ConnectorPainter extends CustomPainter {
  final double fromX, toX;
  final Color color;

  _ConnectorPainter({required this.fromX, required this.toX, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final usable = size.width / 2 - 50;
    final startX = size.width / 2 + fromX * usable;
    final endX = size.width / 2 + toX * usable;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(startX, 0)
      ..quadraticBezierTo(startX, size.height / 2, (startX + endX) / 2, size.height / 2)
      ..quadraticBezierTo(endX, size.height / 2, endX, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter oldDelegate) =>
      oldDelegate.fromX != fromX || oldDelegate.toX != toX || oldDelegate.color != color;
}