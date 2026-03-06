import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import '../models/gym_plan.dart';
import 'payment_promo_screen.dart';

/// Screen 2: Plan Selection. Basic 500k, Premium 1tr, VIP 2tr. If BMI > 30, warn and disable Basic.
class PlanSelectionScreen extends StatelessWidget {
  const PlanSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Selection')),
      body: Consumer<ZenFitState>(
        builder: (context, state, _) {
          final isObesity = state.isObesity;
          final selected = state.selectedPlan;
          final canProceed = state.canProceedFromPlanSelection;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isObesity)
                  Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.orange.shade800),
                              const SizedBox(width: 8),
                              Text(
                                'Health notice',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your BMI is over 30 (obesity range). We recommend choosing Premium or VIP for better support.',
                            style: TextStyle(color: Colors.orange.shade900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'If you select Basic, you cannot proceed for health reasons.',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isObesity) const SizedBox(height: 16),
                ...GymPlan.values.map((plan) {
                  final disabled = isObesity && plan == GymPlan.basic;
                  final isSelected = selected == plan;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: disabled
                          ? null
                          : () => context.read<ZenFitState>().setPlan(plan),
                      child: Card(
                        color: isSelected ? Colors.teal.shade50 : null,
                        child: ListTile(
                          title: Text(plan.label),
                          subtitle: Text(plan.priceDisplay),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.teal)
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                if (isObesity && selected == GymPlan.basic)
                  Text(
                    'Select Premium or VIP to continue (Basic is disabled for health reasons).',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: canProceed
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaymentPromoScreen(),
                            ),
                          )
                      : null,
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
