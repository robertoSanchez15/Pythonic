import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Banner superior de Home.
///
/// Muestra la unidad/mundo actual y, cuando corresponde, la lección
/// actualmente activa como subtítulo dinámico. El fondo usa un
/// degradado de tres tonos derivados de [accentColor] más una textura
/// diagonal sutil, para que el diseño se sienta con profundidad sin
/// importar qué color de unidad se use (excepto blanco o negro).
class WorldBanner extends StatefulWidget {
  final String label;
  final String title;
  final Color accentColor;

  /// Título de la lección actualmente activa en el scroll.
  final String? currentSubtitle;

  const WorldBanner({
    super.key,
    required this.label,
    required this.title,
    required this.accentColor,
    this.currentSubtitle,
  });

  @override
  State<WorldBanner> createState() => _WorldBannerState();
}

class _WorldBannerState extends State<WorldBanner>
    with SingleTickerProviderStateMixin {
  static const _iconAsset = 'assets/analysis.png';

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Primer reflejo después de 1 segundo.
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _startLoop();
      }
    });
  }

  void _startLoop() {
    if (!mounted) return;

    _controller.forward(from: 0).then((_) {
      if (!mounted) return;

      // Espera 3 segundos antes del siguiente reflejo.
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _startLoop();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darken(Color color, double amount) => _lighten(color, -amount);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ---------------------------------------------------------------
        // Tamaño disponible
        // ---------------------------------------------------------------
        final width = constraints.maxWidth;

        // ---------------------------------------------------------------
        // Valores responsive.
        // ---------------------------------------------------------------
        final horizontalMargin = width < 360
            ? 16.0
            : width < 400
                ? 18.0
                : 20.0;

        final horizontalPadding = width < 360
            ? 14.0
            : width < 400
                ? 16.0
                : 18.0;

        final verticalPadding = width < 360 ? 12.0 : 14.0;

        final iconSize = width < 360
            ? 36.0
            : width < 400
                ? 38.0
                : 40.0;

        final titleFontSize = width < 360 ? 17.0 : 18.0;

        final accent = widget.accentColor;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double position = 1.5 - (_controller.value * 3.0);

            return Container(
              margin: EdgeInsets.fromLTRB(
                horizontalMargin,
                4,
                horizontalMargin,
                12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _lighten(accent, 0.06),
                    accent,
                    _darken(accent, 0.16),
                  ],
                  stops: const [0, 0.5, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // =======================================================
                  // TEXTURA DE FONDO
                  // =======================================================
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DiagonalPatternPainter(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ),

                  // =======================================================
                  // REFLEJO
                  // =======================================================
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(position - 0.22, -1),
                            end: Alignment(position + 0.22, 1),
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: 0.24),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =======================================================
                  // FILO BRILLANTE INFERIOR (efecto "cristal")
                  // =======================================================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 1.2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.35),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =======================================================
                  // CONTENIDO
                  // =======================================================
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // -------------------------------------------------
                        // TEXTO
                        // -------------------------------------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Label como "pill" en vez de texto plano.
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withValues(alpha: 0.14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  widget.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.arimo(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.arimo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: titleFontSize,
                                  height: 1.15,
                                ),
                              ),

                              // -------------------------------------------------
                              // SUBTÍTULO DINÁMICO
                              // -------------------------------------------------
                              AnimatedSize(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutCubic,
                                alignment: Alignment.topLeft,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 220),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        axisAlignment: -1,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: widget.currentSubtitle == null
                                      ? const SizedBox(
                                          width: double.infinity,
                                          height: 0,
                                        )
                                      : Padding(
                                          key: ValueKey(widget.currentSubtitle),
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 1,
                                                width: 28,
                                                margin: const EdgeInsets.only(
                                                  bottom: 6,
                                                ),
                                                color: Colors.white
                                                    .withValues(alpha: 0.3),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.chevron_right_rounded,
                                                    size: 15,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.75),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Flexible(
                                                    child: Text(
                                                      widget.currentSubtitle!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.arimo(
                                                        color: Colors.white
                                                            .withValues(
                                                          alpha: 0.85,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // -------------------------------------------------
                        // SEPARACIÓN ENTRE TEXTO E ÍCONO
                        // -------------------------------------------------
                        SizedBox(width: width < 360 ? 8 : 14),

                        // -------------------------------------------------
                        // ÍCONO con halo suave (sin contenedor)
                        // -------------------------------------------------
                        SizedBox(
                          width: iconSize + 24,
                          height: iconSize + 24,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: iconSize + 24,
                                height: iconSize + 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      blurRadius: 22,
                                      spreadRadius: -6,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: iconSize,
                                height: iconSize,
                                child: Image.asset(
                                  _iconAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Textura de líneas diagonales muy sutil que le da profundidad al
/// banner sin competir con el texto ni con la animación de brillo.
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