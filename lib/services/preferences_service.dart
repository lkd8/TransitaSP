import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rotina.dart';

class PreferencesService {
  static const String _onboardingKey = 'onboarding_visto';
  static const String _rotinasKey = 'rotinas';
  static const String _minutosKey = 'minutos_economizados';
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<bool> getOnboardingVisto() async {
    return await _preferences.getBool(_onboardingKey) ?? false;
  }

  Future<void> saveOnboardingVisto(bool value) async {
    await _preferences.setBool(_onboardingKey, value);
  }

  Future<List<Rotina>> getRotinas() async {
    final lista = await _preferences.getStringList(_rotinasKey) ?? [];
    return lista.map((item) => Rotina.fromJson(jsonDecode(item))).toList();
  }

  Future<void> saveRotinas(List<Rotina> rotinas) async {
    final lista = rotinas.map((r) => jsonEncode(r.toJson())).toList();
    await _preferences.setStringList(_rotinasKey, lista);
  }

  Future<int> getMinutosEconomizados() async {
    return await _preferences.getInt(_minutosKey) ?? 0;
  }

  Future<void> saveMinutosEconomizados(int value) async {
    await _preferences.setInt(_minutosKey, value);
  }

  Future<ThemeMode> getThemeMode() async {
    final mode = await _preferences.getString(_themeModeKey) ?? 'system';

    if (mode == 'dark') {
      return ThemeMode.dark;
    }

    if (mode == 'light') {
      return ThemeMode.light;
    }

    return ThemeMode.system;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    String value;

    switch (mode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }

    await _preferences.setString(_themeModeKey, value);
  }
}
