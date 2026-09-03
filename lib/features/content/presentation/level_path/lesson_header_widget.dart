import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Encabezado de una lección dentro del camino de ejercicios.
///
/// Diseño "medallón": el badge numerado sobresale del borde izquierdo
/// de la tarjeta, como una moneda incrustada, sobre una textura
/// diagonal sutil que le da profundidad sin distraer del título.
/// Como este header siempre usa el mismo azul fijo, la personalidad
/// viene de la forma, no del color.
class LessonHeaderWidget extends StatelessWidget {
  final String title;

  /// Número de la lección dentro de su unidad (1, 2, 3...). Opcional:
  /// si no se provee, la tarjeta no muestra el badge ni el divisor.
  final int? index;

  const LessonHeaderWidget({super.key, required this.title, this.index});

  static const double _badgeSize = 46;

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darken(Color color, double amount) => _lighten(color, -amount);

  @override
  Widget build(BuildContext context) {
    final base = AppColors.lesson1;
    final hasBadge = index != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: hasBadge ? _badgeSize / 2 : 0),
            padding: EdgeInsets.fromLTRB(
              hasBadge ? _badgeSize / 2 + 20 : 18,
              18,
              18,
              18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _lighten(base, 0.05),
                  base,
                  _darken(base, 0.15),
                ],
                stops: const [0, 0.55, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: base.withValues(alpha: 0.32),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DiagonalPatternPainter(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (hasBadge) ...[
                      Container(
                        width: 1,
                        height: 26,
                        color: Colors.white.withValues(alpha: 0.24),
                      ),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasBadge)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: _badgeSize,
                  height: _badgeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_lighten(base, 0.14), _darken(base, 0.05)],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: base.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    index!.toString().padLeft(2, '0'),
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Textura de líneas diagonales muy sutil, compartida en espíritu con
/// la del WorldBanner, para dar una identidad visual consistente al
/// camino de lecciones sin recurrir a más color.
class _DiagonalPatternPainter extends CustomPainter {
  final Color color;
  const _DiagonalPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const gap = 16.0;
    final span = size.width + size.height;
    for (double x = -span; x < span; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}