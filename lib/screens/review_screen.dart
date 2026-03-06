import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/zenfit_state.dart';
import 'profile_setup_screen.dart';
import 'plan_selection_screen.dart';
import 'dashboard_screen.dart';
import '../widgets/zen_background.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  String _formatVnd(int amount) {
    final s = amount.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    final out = buf.toString();
    return '${amount < 0 ? '-' : ''}$out VND';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review & Confirm')),
      body: ZenBackground(
        child: Consumer<ZenFitState>(
          builder: (context, state, _) {
            final bmi = state.bmi;
            final age = state.age;
            final plan = state.selectedPlan;
            final scheme = Theme.of(context).colorScheme;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Text(
                  'Review your registration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Confirm everything looks correct before finishing.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.badge_outlined, color: scheme.primary),
                            const SizedBox(width: 10),
                            Text(
                              'Profile',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _kv('Full name', state.fullName),
                        _kv('Gender', state.gender),
                        if (age != null) _kv('Age', '$age'),
                        if (state.weightKg != null) _kv('Weight', '${state.weightKg!.toStringAsFixed(1)} kg'),
                        if (state.heightCm != null) _kv('Height', '${state.heightCm!.toStringAsFixed(1)} cm'),
                        if (bmi != null) _kv('BMI', bmi.toStringAsFixed(1), emphasize: (bmi > 30)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt_long, color: scheme.primary),
                            const SizedBox(width: 10),
                            Text(
                              'Plan & payment',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _kv(
                          'Plan',
                          plan == null ? 'Not selected' : '${plan.label} (${plan.priceDisplay})',
                        ),
                        _kv('Promo code', state.promoCode.isEmpty ? 'None' : state.promoCode),
                        const Divider(height: 18),
                        _kv('Subtotal', _formatVnd(state.totalBeforePromo)),
                        _kv('Discount', _formatVnd(-state.discountAmount)),
                        const Divider(height: 18),
                        _kv('Final total', _formatVnd(state.finalPrice), bold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileSetupScreen(),
                          ),
                        );
                      },
                      child: const Text('Edit profile'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PlanSelectionScreen(),
                          ),
                        );
                      },
                      child: const Text('Edit plan & promo'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    );
                  },
                  child: const Text('Confirm & continue'),
                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _kv(String k, String v, {bool bold = false, bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.65),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: emphasize ? Colors.red.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }
}

