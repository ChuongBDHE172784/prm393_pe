import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import 'plan_selection_screen.dart';
import '../widgets/zen_background.dart';

/// Screen 1: Profile Setup. Name, DOB, Gender, Weight, Height. Auto BMI. Continue -> Plan Selection.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
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
    if (_dob != null) {
      _dobController.text = _formatDob(_dob!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String _formatDob(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yyyy = d.year.toString().padLeft(4, '0');
    return '$mm/$dd/$yyyy';
  }

  DateTime? _tryParseDobDigits(String digits) {
    if (digits.length != 8) return null;
    final mm = int.tryParse(digits.substring(0, 2));
    final dd = int.tryParse(digits.substring(2, 4));
    final yyyy = int.tryParse(digits.substring(4, 8));
    if (mm == null || dd == null || yyyy == null) return null;
    if (mm < 1 || mm > 12) return null;
    if (yyyy < 1900 || yyyy > DateTime.now().year) return null;
    final maxDay = DateTime(yyyy, mm + 1, 0).day;
    if (dd < 1 || dd > maxDay) return null;
    return DateTime(yyyy, mm, dd);
  }

  DateTime? _tryParseDobText(String text) {
    final cleaned = text.trim();
    final digits = cleaned.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 8) return _tryParseDobDigits(digits);
    if (cleaned.contains('/')) {
      final parts = cleaned.split('/');
      if (parts.length == 3) {
        final mm = int.tryParse(parts[0]);
        final dd = int.tryParse(parts[1]);
        final yyyy = int.tryParse(parts[2]);
        if (mm == null || dd == null || yyyy == null) return null;
        if (mm < 1 || mm > 12) return null;
        if (yyyy < 1900 || yyyy > DateTime.now().year) return null;
        final maxDay = DateTime(yyyy, mm + 1, 0).day;
        if (dd < 1 || dd > maxDay) return null;
        return DateTime(yyyy, mm, dd);
      }
    }
    return null;
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
      body: ZenBackground(
        child: Consumer<ZenFitState>(
          builder: (context, state, _) {
            double? bmi;
            final w = _parseDouble(_weightController.text);
            final h = _parseDouble(_heightController.text);
            if (w != null && h != null && w > 0 && h > 0) {
              bmi = w / ((h / 100) * (h / 100));
            }
            final dobError = (_dobController.text.trim().isEmpty || _dob != null)
                ? null
                : 'Invalid date. Use MM/DD/YYYY (e.g. 10/31/2003) or type 8 digits.';
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth (MM/DD/YYYY)',
                      errorText: dobError,
                      helperText: 'Tip: type 8 digits, e.g. 10312003 → 10/31/2003',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _dob ?? DateTime(2003, 10, 31),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (d == null) return;
                          setState(() {
                            _dob = d;
                            _dobController.text = _formatDob(d);
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (v) {
                      final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                      if (digits.length == 8) {
                        final parsed = _tryParseDobDigits(digits);
                        if (parsed != null) {
                          final formatted = _formatDob(parsed);
                          setState(() {
                            _dob = parsed;
                            _dobController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          });
                          return;
                        }
                      }
                      setState(() {
                        _dob = _tryParseDobText(v);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
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
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
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
      ),
    );
  }
}
