//lib\core\l10n\locale_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale';
const _supportedCodes = ['es', 'en'];

class LocaleController extends Notifier<Locale> {
  LocaleController([this._initial]);

  final Locale? _initial;

  @override
  Locale build() => _initial ?? const Locale('es');

  /// Cambia el idioma y lo guarda para futuras sesiones.
  Future<void> setLocale(Locale locale) async {
    state = locale;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _kLocaleKey,
      locale.languageCode,
    );
  }

  /// Inicializa el idioma cargado al arrancar la aplicación.
  ///
  /// No vuelve a guardarlo en SharedPreferences porque ya fue leído
  /// desde allí.
  void initializeLocale(Locale locale) {
    state = locale;
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

Future<Locale> loadInitialLocale() async {
  final prefs = await SharedPreferences.getInstance();

  final saved = prefs.getString(_kLocaleKey);

  if (saved != null && _supportedCodes.contains(saved)) {
    return Locale(saved);
  }

  final deviceCode =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  return Locale(
    _supportedCodes.contains(deviceCode)
        ? deviceCode
        : 'es',
  );
}

// ==========================================================================
// FLAG DE PRIMERA VEZ (LanguageSelect)
// ==========================================================================

const _kHasSeenLanguageSelectKey =
    'has_seen_language_select';

Future<bool> hasSeenLanguageSelect() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getBool(
        _kHasSeenLanguageSelectKey,
      ) ??
      false;
}

Future<void> markLanguageSelectSeen() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    _kHasSeenLanguageSelectKey,
    true,
  );
}