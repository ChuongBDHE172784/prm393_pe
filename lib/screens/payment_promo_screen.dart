import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import 'review_screen.dart';
import '../widgets/zen_background.dart';

/// Screen 3: Payment & Promo. GIAM50 if total > 1.5tr; TANTHU if age < 22. Continue -> Review.
class PaymentPromoScreen extends StatefulWidget {
  const PaymentPromoScreen({super.key});

  @override
  State<PaymentPromoScreen> createState() => _PaymentPromoScreenState();
}

class _PaymentPromoScreenState extends State<PaymentPromoScreen> {
  final _promoController = TextEditingController();
  bool _didInitText = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitText) return;
    final state = context.read<ZenFitState>();
    if (state.promoCode.isNotEmpty) {
      _promoController.text = state.promoCode;
    }
    _didInitText = true;
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment & Promo')),
      body: ZenBackground(
        child: Consumer<ZenFitState>(
          builder: (context, state, _) {
            final plan = state.selectedPlan;
            final total = state.totalBeforePromo;
            final finalPrice = state.finalPrice;
            final giam50 = state.promoGiam50Applied;
            final tanThu = state.promoTanThuApplied;
            final scheme = Theme.of(context).colorScheme;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Text(
                  'Payment summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Apply promo codes to get discounts (if eligible).',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                if (plan != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selected plan: ${plan.label}',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            _formatVnd(total),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _promoController,
                  decoration: InputDecoration(
                    labelText: 'Promo code',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear promo',
                      onPressed: () {
                        _promoController.clear();
                        context.read<ZenFitState>().setPromo('');
                      },
                    ),
                  ),
                  onChanged: (v) => context.read<ZenFitState>().setPromo(v),
                  onSubmitted: (v) => context.read<ZenFitState>().setPromo(v),
                ),
                const SizedBox(height: 8),
                Text(
                  'Only 1 promo code can be used. GIAM50: 50% off when subtotal > 1.5M. TANTHU: -100k for users under 22.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusChip(
                      context,
                      label: 'GIAM50',
                      applied: giam50,
                      note: total > 1500000 ? 'Eligible' : 'Need > 1.5M',
                    ),
                    _statusChip(
                      context,
                      label: 'TANTHU',
                      applied: tanThu,
                      note: (state.age ?? 999) < 22 ? 'Eligible' : 'Need age < 22',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row('Subtotal', _formatVnd(total)),
                        if (giam50) _row('GIAM50 (50% off)', _formatVnd(-(total ~/ 2))),
                        if (tanThu) _row('TANTHU (100k off)', _formatVnd(-100000)),
                        const Divider(),
                        _row('Total', _formatVnd(finalPrice), bold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReviewScreen()),
                  ),
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

  Widget _statusChip(
    BuildContext context, {
    required String label,
    required bool applied,
    required String note,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final bg = applied ? scheme.primary.withValues(alpha: 0.12) : scheme.surfaceContainerHighest;
    final fg = applied ? scheme.primary : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: applied ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(applied ? Icons.check_circle : Icons.info_outline, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(
            '$label • $note',
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
