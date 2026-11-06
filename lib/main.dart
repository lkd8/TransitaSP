import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/preferences_service.dart';
import 'theme/theme_toggle_scope.dart';

void main() {
  runApp(const TransitaSPApp());
}

class TransitaSPApp extends StatefulWidget {
  const TransitaSPApp({super.key});

  @override
  State<TransitaSPApp> createState() => _TransitaSPAppState();
}

class _TransitaSPAppState extends State<TransitaSPApp> {
  final PreferencesService _preferencesService = PreferencesService();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final themeMode = await _preferencesService.getThemeMode();

    if (!mounted) return;

    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _alternarTema() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });

    await _preferencesService.saveThemeMode(_themeMode);
  }

  ThemeData _buildTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final foreground =
        brightness == Brightness.dark ? Colors.white : Colors.black87;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: brightness,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? colorScheme.surface
          : const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF111827)
            : Colors.white,
        foregroundColor: foreground,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeToggleScope(
      themeMode: _themeMode,
      toggleTheme: _alternarTema,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TransitaSP',
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: _themeMode,
        home: SplashScreen(onThemeToggle: _alternarTema),
      ),
    );
  }
}
