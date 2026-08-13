import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../mascot/data/svgator/pip_greeting.dart';

class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({super.key});

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  // Guardamos cuál idioma está seleccionado (por defecto 'es')
  String _selectedCode = 'es';

  @override
  Widget build(BuildContext context) {
    // Color de fondo exacto de la pantalla para la máscara
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. PIP CON MÁSCARA PARA LA MARCA DE AGUA
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Pipgreeting(
                      width: 220,
                      height: 220,
                    ),

                    // Parche para ocultar "Made with svgator"
                    Positioned(
                      bottom: 32,
                      right: 15,
                      child: Container(
                        width: 75,
                        height: 20,
                        color: backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. TÍTULO
              const Text(
                '¿En qué idioma quieres\naprender Python?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 32),

              // 3. BOTONES DE IDIOMA
              _LanguageButton(
                imagePath: 'assets/spain_flag.png',
                title: 'Español',
                isSelected: _selectedCode == 'es',
                onTap: () {
                  setState(() => _selectedCode = 'es');
                  context.go('/home');
                },
              ),

              const SizedBox(height: 16),

              _LanguageButton(
                imagePath: 'assets/united_kingdom.png',
                title: 'English',
                isSelected: _selectedCode == 'en',
                onTap: () {
                  setState(() => _selectedCode = 'en');
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// COMPONENTE DE BOTÓN MEJORADO
// ----------------------------------------------------
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
    const primaryGreen = Color(0xFF2EA043);
    const activeBgColor = Color(0xFFF0FDF4); // Verde pastel suave

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? activeBgColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryGreen : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? primaryGreen.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Bandera
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  imagePath,
                  width: 48,
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 20),

              // Texto del Idioma
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? primaryGreen
                        : Colors.black.withValues(alpha: 0.8),
                  ),
                ),
              ),

              // Indicador de selección
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: primaryGreen,
                  size: 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}