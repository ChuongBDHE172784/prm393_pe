import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/ai_prompt_item.dart';
import 'ai_response_detail_screen.dart';
import '../widgets/zen_background.dart';

class AiHistoryScreen extends StatelessWidget {
  const AiHistoryScreen({super.key});

  Future<List<AiPromptItem>> _loadHistory() async {
    final jsonString = await rootBundle.loadString('assets/ai_prompt_history.json');
    final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
    return data
        .map((e) => AiPromptItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Prompt History')),
      body: ZenBackground(
        child: FutureBuilder<List<AiPromptItem>>(
          future: _loadHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load history: ${snapshot.error}'),
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('No AI prompts found.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.shortTitle),
                    subtitle: Text('${item.date} ${item.time}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AiResponseDetailScreen(item: item),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

