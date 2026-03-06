import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/zenfit_state.dart';
import 'ai_history_screen.dart';
import '../widgets/zen_background.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      appBar: AppBar(title: const Text('Member Dashboard')),
      body: ZenBackground(
        child: Consumer<ZenFitState>(
          builder: (context, state, _) {
            final plan = state.selectedPlan;
            final displayName =
                state.fullName.isNotEmpty ? state.fullName : (state.studentName ?? '');
            final scheme = Theme.of(context).colorScheme;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [scheme.primary, scheme.primaryContainer],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ZenFit Member',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          if (state.studentId != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Student ID: ${state.studentId}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            'Plan: ${plan?.label ?? 'Not selected'}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total paid: ${_formatVnd(state.finalPrice)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                              ),
                              child: const Text(
                                'ACTIVE MEMBER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AiHistoryScreen(),
                          ),
                        );
                      },
                      child: const Text('Hết bài làm'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

