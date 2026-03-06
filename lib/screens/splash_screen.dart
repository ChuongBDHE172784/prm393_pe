import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import '../models/student_info.dart';
import 'profile_setup_screen.dart';

/// Splash: load student_info.json, show name/student_id/email + logo, 5 seconds then navigate to Profile Setup.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Loading...';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    try {
      final jsonString = await rootBundle.loadString('assets/student_info.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final info = StudentInfo.fromJson(json);
      if (!mounted) return;
      context.read<ZenFitState>().setStudentInfo(
            name: info.name,
            id: info.studentId,
            email: info.email,
          );
      setState(() {
        _status = '';
        _loaded = true;
      });
      await Future<void>.delayed(const Duration(seconds: 5));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
      );
    } catch (e) {
      setState(() => _status = 'Error: $e');
      await Future<void>.delayed(const Duration(seconds: 5));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ZenFitState>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade700, Colors.teal.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'ZenFit',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              if (_loaded) ...[
                Text(
                  state.studentName ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  state.studentId ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  state.studentEmail ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ] else
                Text(
                  _status,
                  style: TextStyle(color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
