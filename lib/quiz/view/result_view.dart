import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';

// A ResultView a kvíz eredményét jeleníti meg a játék végén.
// Ez a nézet megmutatja a játékos pontszámát, egy ikon segítségével ünnepli a teljesítményt,
// és egy gombot kínál az újraindításhoz.

class ResultView extends StatelessWidget {
  final int score;

  const ResultView({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 80,
            color: Colors.amber,
          ),

          const SizedBox(height: 16),

          const Text(
            'Kvíz vége!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Pontszámod: $score',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<QuizCubit>().restart();
            },
            label: const Text('Újrakezdés'),
          ),
        ],
      ),
    );
  }
}
