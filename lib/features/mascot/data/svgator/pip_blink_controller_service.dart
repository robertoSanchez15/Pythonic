import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

class PipBlinkControllerService {
  PipBlinkControllerService._();

  static final PipBlinkControllerService instance =
      PipBlinkControllerService._();

  WebViewController? _controller;

  bool _isLoading = false;
  bool _isReady = false;

  Completer<void>? _readyCompleter;

  final List<void Function()> _readyListeners = [];

  WebViewController? get controller => _controller;

  bool get isReady => _isReady;

  Future<void> preload() async {
    if (_isReady && _controller != null) {
      return;
    }

    if (_isLoading) {
      return waitUntilReady();
    }

    _isLoading = true;
    _readyCompleter = Completer<void>();

    try {
      final svgContent =
          await rootBundle.loadString('assets/blink.svg');

      final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >

  <style>
    html,
    body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: transparent;
    }

    body {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    svg {
      width: 100%;
      height: 100%;
      display: block;
    }
  </style>
</head>

<body>
  $svgContent
</body>
</html>
''';

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              _isReady = true;
              _isLoading = false;

              if (_readyCompleter != null &&
                  !_readyCompleter!.isCompleted) {
                _readyCompleter!.complete();
              }

              final listeners =
                  List<void Function()>.from(_readyListeners);

              _readyListeners.clear();

              for (final listener in listeners) {
                listener();
              }
            },
          ),
        );

      _controller = controller;

      await controller.loadHtmlString(html);
    } catch (e) {
      _isLoading = false;

      if (_readyCompleter != null &&
          !_readyCompleter!.isCompleted) {
        _readyCompleter!.completeError(e);
      }

      rethrow;
    }
  }

  Future<void> waitUntilReady() async {
    if (_isReady && _controller != null) {
      return;
    }

    if (!_isLoading) {
      await preload();
      return;
    }

    await _readyCompleter?.future;
  }

  void onReady(void Function() callback) {
    if (_isReady && _controller != null) {
      callback();
      return;
    }

    _readyListeners.add(callback);
  }
}