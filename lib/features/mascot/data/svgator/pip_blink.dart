//lib\features\mascot\data\svgator\pip_blink.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'pip_blink_controller_service.dart';

class PipBlink extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const PipBlink({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<PipBlink> createState() => _PipBlinkState();
}

class _PipBlinkState extends State<PipBlink> {
  @override
  void initState() {
    super.initState();

    final service = PipBlinkControllerService.instance;
    service.preload();

    // Si el WebView todavía no está listo cuando este widget se
    // construye, nos suscribimos para reconstruir en cuanto lo esté.
    if (!service.isReady) {
      service.onReady(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = PipBlinkControllerService.instance.controller;

    if (controller == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebViewWidget(controller: controller),
    );
  }
}