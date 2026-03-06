import 'package:flutter/material.dart';

import '../models/ai_prompt_item.dart';

class AiResponseDetailScreen extends StatelessWidget {
  const AiResponseDetailScreen({super.key, required this.item});

  final AiPromptItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Response Detail')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.date} ${item.time}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Question',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(item.prompt),
              const SizedBox(height: 16),
              Text(
                'Response',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(item.response),
            ],
          ),
        ),
      ),
    );
  }
}

