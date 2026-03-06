import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import '../models/gym_plan.dart';
import 'payment_promo_screen.dart';
import '../widgets/zen_background.dart';

/// Screen 2: Plan Selection. Basic 500k, Premium 1tr, VIP 2tr. If BMI > 30, warn and disable Basic.
class PlanSelectionScreen extends StatelessWidget {
  const PlanSelectionScreen({super.key});

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
      appBar: AppBar(title: const Text('Plan Selection')),
      body: ZenBackground(
        child: Consumer<ZenFitState>(
          builder: (context, state, _) {
            final isObesity = state.isObesity;
            final selected = state.selectedPlan;
            final canProceed = state.canProceedFromPlanSelection;
            final scheme = Theme.of(context).colorScheme;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Text(
                  'Choose your plan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pick a plan that matches your health profile and goals.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                if (isObesity)
                  Card(
                    color: scheme.tertiaryContainer.withValues(alpha: 0.55),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.health_and_safety, color: scheme.tertiary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Health notice (BMI > 30)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: scheme.onTertiaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'We recommend Premium or VIP for better coaching/support.',
                                  style: TextStyle(color: scheme.onTertiaryContainer),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Basic will be disabled for health reasons.',
                                  style: TextStyle(
                                    color: scheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
                  final price = _formatVnd(plan.price);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: disabled
                          ? null
                          : () => context.read<ZenFitState>().setPlan(plan),
                      child: Stack(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? scheme.primary.withValues(alpha: 0.14)
                                          : scheme.surfaceContainerHighest.withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      plan == GymPlan.basic
                                          ? Icons.bolt
                                          : plan == GymPlan.premium
                                              ? Icons.stars
                                              : Icons.workspace_premium,
                                      color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              plan.label,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (plan == GymPlan.vip)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: scheme.primary.withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                  'BEST',
                                                  style: TextStyle(
                                                    color: scheme.primary,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          price,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: scheme.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: isSelected ? scheme.primary : scheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isSelected ? scheme.primary : scheme.outlineVariant,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: isSelected ? scheme.onPrimary : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (disabled)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: scheme.errorContainer.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'Not available (BMI > 30)',
                                      style: TextStyle(
                                        color: scheme.onErrorContainer,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
      ),
    );
  }
}
