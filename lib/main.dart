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
    return ChangeNotifierProvider(
      create: (_) => ZenFitState(),
      child: MaterialApp(
        title: 'ZenFit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
