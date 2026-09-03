import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'pip_controller_service.dart';

class Pipgreeting extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;

  const Pipgreeting({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
  });

  @override
  State<Pipgreeting> createState() => _PipgreetingState();
}

class _PipgreetingState extends State<Pipgreeting> {
  @override
  Widget build(BuildContext context) {
    final controller =
        PipControllerService.instance.controller;

    if (controller == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}