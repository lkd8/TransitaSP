import 'package:flutter/material.dart';

class ThemeToggleScope extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const ThemeToggleScope({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeToggleScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeToggleScope>();
  }

  @override
  bool updateShouldNotify(ThemeToggleScope oldWidget) {
    return themeMode != oldWidget.themeMode ||
        toggleTheme != oldWidget.toggleTheme;
  }
}
