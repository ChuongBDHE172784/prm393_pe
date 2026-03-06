import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/zenfit_state.dart';
import 'ai_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Dashboard')),
      body: Consumer<ZenFitState>(
        builder: (context, state, _) {
          final plan = state.selectedPlan;
          final displayName =
              state.fullName.isNotEmpty ? state.fullName : (state.studentName ?? '');

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
                        colors: [Colors.teal.shade700, Colors.teal.shade300],
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
                          'Total paid: ${state.finalPrice} VND',
                          style: const TextStyle(color: Colors.white),
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
    );
  }
}

