// lib/features/mascot/dialogue_engine/presentation/dialogue_bubble.dart

import 'package:flutter/material.dart';

/// Globo de diálogo reutilizable.
///
/// El globo se adapta automáticamente a la cantidad de texto.
/// Cuando el texto aumenta, el cuerpo crece hacia ARRIBA,
/// manteniendo fijo el pico en la parte inferior.
class DialogueBubble extends StatelessWidget {
  final String text;
  final VoidCallback onContinue;
  final String continueLabel;

  const DialogueBubble({
    super.key,
    required this.text,
    required this.onContinue,
    this.continueLabel = 'Continuar',
  });

  // ==============================================================
  // GEOMETRÍA DEL GLOBO
  // ==============================================================

  static const double _radius = 20;
  static const double _tailWidth = 40;
  static const double _tailHeight = 20;
  static const double _tailLeft = 60;

  // ==============================================================
  // POSICIÓN DEL BOTÓN
  // ==============================================================
  //
  // Mientras más negativo sea este valor, más arriba estará
  // el botón respecto al borde superior del globo.
  //
  static const double _buttonTop = -24;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Permitimos que el botón sobresalga del globo.
      clipBehavior: Clip.none,

      // ============================================================
      // IMPORTANTE
      // ============================================================
      //
      // El contenido del Stack determina su propia altura.
      // No usamos Positioned(bottom: 0) aquí porque ExercisePage
      // ya se encarga de posicionar TODO el DialogueBubble.
      //
      children: [
        // ============================================================
        // GLOBO
        // ============================================================
        CustomPaint(
          painter: _BubblePainter(
            radius: _radius,
            tailWidth: _tailWidth,
            tailHeight: _tailHeight,
            tailLeft: _tailLeft,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              18 + _tailHeight,
            ),
            child: Text(
              text,

              // ======================================================
              // TEXTO JUSTIFICADO
              // ======================================================
              textAlign: TextAlign.justify,

              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),

        // ============================================================
        // BOTÓN CONTINUAR
        // ============================================================
        Positioned(
          top: _buttonTop,
          right: -8,
          child: GestureDetector(
            onTap: onContinue,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2EA043),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    continueLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ================================================================
/// PAINTER DEL GLOBO
/// ================================================================
///
/// Dibuja cuerpo + pico como una única forma continua.
class _BubblePainter extends CustomPainter {
  final double radius;
  final double tailWidth;
  final double tailHeight;
  final double tailLeft;

  _BubblePainter({
    required this.radius,
    required this.tailWidth,
    required this.tailHeight,
    required this.tailLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // La altura del cuerpo excluye el pico.
    final bodyHeight = size.height - tailHeight;

    final path = _buildPath(
      size.width,
      bodyHeight,
    );

    // ============================================================
    // SOMBRA
    // ============================================================

    canvas.save();

    canvas.translate(0, 6);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        6,
      );

    canvas.drawPath(
      path,
      shadowPaint,
    );

    canvas.restore();

    // ============================================================
    // RELLENO
    // ============================================================

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      path,
      fillPaint,
    );

    // ============================================================
    // BORDE
    // ============================================================

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      path,
      borderPaint,
    );
  }

  // ==============================================================
  // CONSTRUCCIÓN DEL PATH
  // ==============================================================

  Path _buildPath(
    double width,
    double height,
  ) {
    final tailTipX = tailLeft + tailWidth / 2;
    final r = radius;

    return Path()
      // ------------------------------------------------------------
      // ESQUINA SUPERIOR IZQUIERDA
      // ------------------------------------------------------------
      ..moveTo(r, 0)

      // ------------------------------------------------------------
      // PARTE SUPERIOR
      // ------------------------------------------------------------
      ..lineTo(width - r, 0)

      // ------------------------------------------------------------
      // ESQUINA SUPERIOR DERECHA
      // ------------------------------------------------------------
      ..arcToPoint(
        Offset(width, r),
        radius: Radius.circular(r),
      )

      // ------------------------------------------------------------
      // LADO DERECHO
      // ------------------------------------------------------------
      ..lineTo(
        width,
        height - r,
      )

      // ------------------------------------------------------------
      // ESQUINA INFERIOR DERECHA
      // ------------------------------------------------------------
      ..arcToPoint(
        Offset(width - r, height),
        radius: Radius.circular(r),
      )

      // ------------------------------------------------------------
      // BASE DERECHA → PICO
      // ------------------------------------------------------------
      ..lineTo(
        tailLeft + tailWidth,
        height,
      )

      // ------------------------------------------------------------
      // PUNTA DEL PICO
      // ------------------------------------------------------------
      ..lineTo(
        tailTipX,
        height + tailHeight,
      )

      // ------------------------------------------------------------
      // PICO → BASE IZQUIERDA
      // ------------------------------------------------------------
      ..lineTo(
        tailLeft,
        height,
      )

      // ------------------------------------------------------------
      // BASE IZQUIERDA
      // ------------------------------------------------------------
      ..lineTo(
        r,
        height,
      )

      // ------------------------------------------------------------
      // ESQUINA INFERIOR IZQUIERDA
      // ------------------------------------------------------------
      ..arcToPoint(
        Offset(0, height - r),
        radius: Radius.circular(r),
      )

      // ------------------------------------------------------------
      // LADO IZQUIERDO
      // ------------------------------------------------------------
      ..lineTo(0, r)

      // ------------------------------------------------------------
      // ESQUINA SUPERIOR IZQUIERDA
      // ------------------------------------------------------------
      ..arcToPoint(
        Offset(r, 0),
        radius: Radius.circular(r),
      )

      ..close();
  }

  @override
  bool shouldRepaint(
    covariant _BubblePainter oldDelegate,
  ) {
    return oldDelegate.radius != radius ||
        oldDelegate.tailWidth != tailWidth ||
        oldDelegate.tailHeight != tailHeight ||
        oldDelegate.tailLeft != tailLeft;
  }
}