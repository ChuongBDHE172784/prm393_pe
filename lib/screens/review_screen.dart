import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/zenfit_state.dart';
import 'profile_setup_screen.dart';
import 'plan_selection_screen.dart';
import 'dashboard_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review & Confirm')),
      body: Consumer<ZenFitState>(
        builder: (context, state, _) {
          final bmi = state.bmi;
          final age = state.age;
          final plan = state.selectedPlan;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Profile summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full name: ${state.fullName}'),
                        if (age != null) Text('Age: $age'),
                        Text('Gender: ${state.gender}'),
                        if (state.weightKg != null)
                          Text('Weight: ${state.weightKg!.toStringAsFixed(1)} kg'),
                        if (state.heightCm != null)
                          Text('Height: ${state.heightCm!.toStringAsFixed(1)} cm'),
                        if (bmi != null)
                          Text('BMI: ${bmi.toStringAsFixed(1)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Plan & payment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan == null
                              ? 'Plan: not selected'
                              : 'Plan: ${plan.label} (${plan.priceDisplay})',
                        ),
                        const SizedBox(height: 8),
                        Text('Promo code: ${state.promoCode.isEmpty ? 'None' : state.promoCode}'),
                        const SizedBox(height: 8),
                        Text('Subtotal: ${state.totalBeforePromo} VND'),
                        Text('Discount: -${state.discountAmount} VND'),
                        const Divider(),
                        Text(
                          'Final total: ${state.finalPrice} VND',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
    );
  }
}

