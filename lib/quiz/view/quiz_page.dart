import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/view/result_view.dart';
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
            return ResultView(score: state.score);
          }

          final questions = state.questions;

          final question = questions[state.currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.2, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    question.question,
                    key: ValueKey(question.id),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text('Pontszám: ${state.score}'),

                const SizedBox(height: 20),

                if (state.isAnswered)
                  Row(
                    children: [
                      Icon(
                        state.wasCorrect == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: state.wasCorrect == true
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.wasCorrect == true
                            ? 'Helyes válasz!'
                            : 'Hibás válasz!',
                        style: TextStyle(
                          color: state.wasCorrect == true
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                if (state.isAnswered && state.wasCorrect == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      'Helyes válasz: ${question.options[question.correctIndex]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                ...question.options.map(
                  (option) {
                    final optionIndex = question.options.indexOf(option);

                    final isCorrect = optionIndex == question.correctIndex;

                    Color? color;

                    if (state.isAnswered) {
                      if (isCorrect) {
                        color = Colors.green;
                      } else {
                        color = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color ?? Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: BorderSide(
                                color: color ?? Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: state.isAnswered
                                ? null
                                : () async {
                                    final cubit = context.read<QuizCubit>();

                                    final isCorrect =
                                        optionIndex == question.correctIndex;

                                    await cubit.revealAnswerWithDelay(
                                      isCorrect,
                                    );
                                    await cubit.goNextAfterDelay();
                                  },
                            child: Text(option),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
