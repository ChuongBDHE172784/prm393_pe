import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import 'plan_selection_screen.dart';

/// Screen 1: Profile Setup. Name, DOB, Gender, Weight, Height. Auto BMI. Continue -> Plan Selection.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  DateTime? _dob;
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    final state = context.read<ZenFitState>();
    _nameController.text = state.fullName;
    _dob = state.dateOfBirth;
    _gender = state.gender;
    if (state.weightKg != null) _weightController.text = state.weightKg.toString();
    if (state.heightCm != null) _heightController.text = state.heightCm.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  double? _parseDouble(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.trim());
  }

  bool get _valid {
    if (_nameController.text.trim().isEmpty) return false;
    if (_dob == null) return false;
    final w = _parseDouble(_weightController.text);
    final h = _parseDouble(_heightController.text);
    if (w == null || w <= 0) return false;
    if (h == null || h <= 0) return false;
    return true;
  }

  void _continue() {
    if (!_valid) return;
    final w = _parseDouble(_weightController.text)!;
    final h = _parseDouble(_heightController.text)!;
    context.read<ZenFitState>().setProfile(
          name: _nameController.text.trim(),
          dob: _dob,
          g: _gender,
          w: w,
          h: h,
        );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlanSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Consumer<ZenFitState>(
        builder: (context, state, _) {
          double? bmi;
          final w = _parseDouble(_weightController.text);
          final h = _parseDouble(_heightController.text);
          if (w != null && h != null && w > 0 && h > 0) {
            bmi = w / ((h / 100) * (h / 100));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(_dob == null
                      ? 'Date of Birth'
                      : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _dob ?? DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) setState(() => _dob = d);
                  },
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _gender,
                  isExpanded: true,
                  items: ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                if (bmi != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'BMI: ${bmi.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _valid ? _continue : null,
                  child: const Text('Tiếp tục'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
