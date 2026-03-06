import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/zenfit_state.dart';
import '../models/gym_plan.dart';
import 'review_screen.dart';

/// Screen 3: Payment & Promo. GIAM50 if total > 1.5tr; TANTHU if age < 22. Continue -> Review.
class PaymentPromoScreen extends StatefulWidget {
  const PaymentPromoScreen({super.key});

  @override
  State<PaymentPromoScreen> createState() => _PaymentPromoScreenState();
}

class _PaymentPromoScreenState extends State<PaymentPromoScreen> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment & Promo')),
      body: Consumer<ZenFitState>(
        builder: (context, state, _) {
          final plan = state.selectedPlan;
          final total = state.totalBeforePromo;
          final discount = state.discountAmount;
          final finalPrice = state.finalPrice;
          final giam50 = state.promoGiam50Applied;
          final tanThu = state.promoTanThuApplied;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (plan != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selected plan: ${plan.label}',
                              style: Theme.of(context).textTheme.titleMedium),
                          Text('Price: ${plan.priceDisplay}'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _promoController,
                  decoration: InputDecoration(
                    labelText: 'Promo code',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        context.read<ZenFitState>().setPromo(_promoController.text);
                      },
                    ),
                  ),
                  onSubmitted: (v) =>
                      context.read<ZenFitState>().setPromo(v),
                ),
                const SizedBox(height: 8),
                Text(
                  'GIAM50: 50% off when total > 1.5tr. TANTHU: 100k off for users under 22.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row('Subtotal', total),
                        if (giam50) _row('GIAM50 (50% off)', -(total ~/ 2)),
                        if (tanThu) _row('TANTHU (100k off)', -100000),
                        const Divider(),
                        _row('Total', finalPrice, bold: true),
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
    );
  }

  Widget _row(String label, int amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            '${amount >= 0 ? '' : '-'}${amount.abs()} VND',
            style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }
}
