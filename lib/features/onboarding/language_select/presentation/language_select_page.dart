import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../mascot/data/svgator/pip_greeting.dart';

class LanguageSelectPage extends ConsumerStatefulWidget {
  const LanguageSelectPage({super.key});

  @override
  ConsumerState<LanguageSelectPage> createState() =>
      _LanguageSelectPageState();
}

class _LanguageSelectPageState extends ConsumerState<LanguageSelectPage> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();

    // Inicializamos el botón según el idioma actual.
    final currentLocale = ref.read(localeControllerProvider);
    _selectedCode = currentLocale.languageCode;
  }

  Future<void> _selectLanguage(String code) async {
    // Evitamos hacer trabajo si el usuario toca nuevamente
    // el idioma que ya está seleccionado.
    if (_selectedCode == code) {
      return;
    }

    setState(() {
      _selectedCode = code;
    });

    final locale = Locale(code);

    // Cambia el Locale global de toda la aplicación
    // y lo guarda en SharedPreferences.
    await ref.read(localeControllerProvider.notifier).setLocale(locale);

    // Marcamos que el usuario ya pasó por esta pantalla.
    await markLanguageSelectSeen();

    if (!mounted) return;

    // Esperamos a que Flutter tenga oportunidad de
    // reconstruir la interfaz con el nuevo idioma.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.languajePageColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ============================================================
              // PIP
              // ============================================================
              Center(
                child: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Pipgreeting(
                    width: 244,
                    height: 244,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ============================================================
              // PREGUNTA
              // ============================================================
              const Text(
                '¿En qué idioma quieres\naprender Python?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2C31),
                  height: 1.2,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // ESPAÑOL
              // ============================================================
              _LanguageButton(
                imagePath: 'assets/spain_flag.png',
                title: 'Español',
                isSelected: _selectedCode == 'es',
                onTap: () => _selectLanguage('es'),
              ),

              const SizedBox(height: 16),

              // ============================================================
              // ENGLISH
              // ============================================================
              _LanguageButton(
                imagePath: 'assets/united_kingdom.png',
                title: 'English',
                isSelected: _selectedCode == 'en',
                onTap: () => _selectLanguage('en'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// BOTÓN DE IDIOMA
// ==========================================================================

class _LanguageButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF1F2C31);
    const primaryGreen = Color(0xFF2EA043);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: primaryGreen.withValues(alpha: 0.12),
        highlightColor: primaryGreen.withValues(alpha: 0.06),
        child: Ink(
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: darkColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? primaryGreen : darkColor.withValues(alpha: 0.35),
              width: isSelected ? 2.2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: darkColor.withValues(alpha: isSelected ? 0.25 : 0.15),
                blurRadius: isSelected ? 14 : 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // ==========================================================
              // BANDERA
              // ==========================================================
              Container(
                width: 52,
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    imagePath,
                    width: 46,
                    height: 34,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 18),

              // ==========================================================
              // NOMBRE DEL IDIOMA
              // ==========================================================
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              // ==========================================================
              // INDICADOR
              // ==========================================================
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primaryGreen : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? primaryGreen
                        : Colors.white.withValues(alpha: 0.30),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 19,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
