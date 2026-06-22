import 'package:flutter/material.dart';

// Kérdés fejléc, UI
class QuizHeader extends StatelessWidget {
  const QuizHeader({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.score,
    super.key,
  });
  final int currentQuestion;
  final int totalQuestions;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kérdés: $currentQuestion / $totalQuestions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),

            Text(
              'Pontszám: $score',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC107),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        LinearProgressIndicator(
          value: currentQuestion / totalQuestions,
          backgroundColor: const Color(0xFF171A24),
          valueColor: const AlwaysStoppedAnimation(
            Color(0xFFFFC107),
          ),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
