import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

class PipControllerService {
  PipControllerService._();

  static final PipControllerService instance = PipControllerService._();

  WebViewController? _controller;

  bool _isLoading = false;
  bool _isReady = false;

  final List<void Function()> _readyListeners = [];

  Completer<void>? _readyCompleter;

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
          await rootBundle.loadString('assets/pip_greeting.svg');

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

              _readyCompleter?.complete();

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