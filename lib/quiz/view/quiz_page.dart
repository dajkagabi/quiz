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
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pontszám: ${state.score}',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${state.currentQuestionIndex + 1}/${questions.length}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value:
                                (state.currentQuestionIndex + 1) /
                                questions.length,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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

                ...question.options.asMap().entries.map(
                  (entry) {
                    final optionIndex = entry.key;
                    final option = entry.value;
                    final isCorrect = optionIndex == question.correctIndex;
                    final theme = Theme.of(context);
                    final buttonBorderColor = state.isAnswered
                        ? isCorrect
                              ? Colors.green
                              : Colors.red
                        : theme.colorScheme.primary;
                    final buttonBackground = state.isAnswered
                        ? isCorrect
                              ? Colors.green.shade50
                              : Colors.red.shade50
                        : Colors.transparent;
                    final buttonTextColor = state.isAnswered
                        ? isCorrect
                              ? Colors.green.shade900
                              : Colors.red.shade900
                        : theme.colorScheme.onSurface;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: buttonBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: buttonTextColor,
                              shadowColor: Colors.transparent,
                              side: BorderSide(
                                color: buttonBorderColor,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            onPressed: state.isAnswered
                                ? null
                                : () async {
                                    final cubit = context.read<QuizCubit>();

                                    await cubit.revealAnswerWithDelay(
                                      optionIndex == question.correctIndex,
                                    );
                                    await cubit.goNextAfterDelay();
                                  },
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
