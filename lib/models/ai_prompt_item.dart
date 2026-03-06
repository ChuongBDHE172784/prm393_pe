/// Single AI prompt/response from ai_prompt_history.json.
class AiPromptItem {
  final String date;
  final String time;
  final String sender;
  final String receiver;
  final String prompt;
  final String response;

  const AiPromptItem({
    required this.date,
    required this.time,
    required this.sender,
    required this.receiver,
    required this.prompt,
    required this.response,
  });

  factory AiPromptItem.fromJson(Map<String, dynamic> json) {
    return AiPromptItem(
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      response: json['response'] as String? ?? '',
    );
  }

  /// Short title from prompt (first ~50 chars).
  String get shortTitle {
    if (prompt.length <= 50) return prompt;
    return '${prompt.substring(0, 50)}...';
  }
}
