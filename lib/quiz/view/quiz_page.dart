import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/models/question.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

// A QuizPage a quiz alkalmazás fő oldala, ahol a kérdések megjelennek és a felhasználó válaszolhat rájuk.
// A QuizCubit-et használja az állapot kezelésére, és a QuizRepository-t a kérdések betöltésére.
// A kérdések megjelenítése és a válaszok értékelése is itt történik. Amikor a kvíz véget ér, egy eredmény nézet jelenik meg a pontszámmal és egy újraindítás gombbal.
class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(QuizRepository())..loadQuiz(),
      child: const _QuizView(),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magyar Rock Kvíz')),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFinished) {
            return _ResultView(score: state.score);
          }

          if (state.questions.isEmpty) {
            return const Center(
              child: Text('Nincs elérhető kérdés a kvízhez.'),
            );
          }

          final Question question = state.questions[state.currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text('Pontszám: ${state.score}'),

                const SizedBox(height: 24),

                ...question.options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        final optionIndex = question.options.indexOf(option);

                        final isCorrect = optionIndex == question.correctIndex;

                        context.read<QuizCubit>().answer(isCorrect);

                        context.read<QuizCubit>().nextQuestion();
                      },
                      child: Text(option),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;

  const _ResultView({required this.score});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Kvíz vége!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Text(
            'Pontszám: $score',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              context.read<QuizCubit>().restart();
            },
            child: const Text('Újrakezdés'),
          ),
        ],
      ),
    );
  }
}
