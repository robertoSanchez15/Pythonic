//lib\features\lesson\presentation\office_desk.dart

import 'package:flutter/material.dart';

/// Superficie de escritorio nativa. Reemplaza al escritorio dibujado
/// dentro de assets/fondo.jpg — con esto la PC se ancla a un punto
/// exacto y predecible en CUALQUIER dispositivo, sin necesidad de
/// calibrar valores contra un dispositivo de referencia.
class OfficeDesk extends StatelessWidget {
  final double height;

  const OfficeDesk({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFCCCDC6),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -4)),
        ],
      ),
    );
  }
}