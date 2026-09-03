import 'package:flutter/material.dart';

class LevelPathPainter extends CustomPainter {
  final List<Offset> nodeCenters;
  final List<bool> segmentUnlocked; // true = ya recorrido (verde), false = gris

  LevelPathPainter({required this.nodeCenters, required this.segmentUnlocked});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < nodeCenters.length - 1; i++) {
      final start = nodeCenters[i];
      final end = nodeCenters[i + 1];

      final paint = Paint()
        ..color = segmentUnlocked[i] ? const Color(0xFF2EA043) : Colors.grey.shade300
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final controlPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(controlPoint.dx, start.dy, end.dx, end.dy);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LevelPathPainter oldDelegate) =>
      oldDelegate.nodeCenters != nodeCenters ||
      oldDelegate.segmentUnlocked != segmentUnlocked;
}