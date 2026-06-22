import 'package:flutter/material.dart';
import 'package:quiz/quiz/models/question.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.question,
    super.key,
  });
  final Question question;

  // Kérdés kártya, UI
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(question.id),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2332),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      alignment: Alignment.center,
      child: Text(
        question.question,
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.4,
        ),
      ),
    );
  }
}
