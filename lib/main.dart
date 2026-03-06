import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/zenfit_state.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ZenFitApp());
}

class ZenFitApp extends StatelessWidget {
  const ZenFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0B8F87); // richer teal (brighter but still bold)
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ChangeNotifierProvider(
      create: (_) => ZenFitState(),
      child: MaterialApp(
        title: 'ZenFit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: scheme,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4FBFA),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: scheme.onSurface,
            titleTextStyle: TextStyle(
              color: scheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 1,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF0F7F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(width: 1.2, color: scheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            labelStyle: TextStyle(color: scheme.onSurfaceVariant),
            hintStyle: TextStyle(color: scheme.onSurfaceVariant),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: scheme.outlineVariant),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
