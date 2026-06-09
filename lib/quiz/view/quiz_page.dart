import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/view/result_view.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

// A QuizPage a quiz alkalmazás fő oldala,
//  ahol a kérdések megjelennek és a felhasználó válaszolhat rájuk.
// A QuizCubit-et használja az állapot kezelésére,
// és a QuizRepository-t a kérdések betöltésére.
// A kérdések megjelenítése és a válaszok értékelése is itt történik.
// Amikor a kvíz véget ér, egy eredmény nézet jelenik meg a pontszámmal és egy újraindítás gombbal.

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Magyar Rock Kvíz'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFinished) {
            return ResultView(score: state.score);
          }

          final question = state.questions[state.currentQuestionIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress sáv és számláló
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kérdés: ${state.currentQuestionIndex + 1} / ${state.questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Pontszám: ${state.score}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value:
                      (state.currentQuestionIndex + 1) / state.questions.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 24),

                // Kérdés kártya
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    key: ValueKey<String>(question.id),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Válaszlehetőségek listája
                ...List.generate(
                  question.options.length,
                  (optionIndex) {
                    final option = question.options[optionIndex];

                    Color buttonColor = Colors.white;
                    Color textColor = Colors.black87;

                    if (state.isAnswered) {
                      if (optionIndex == question.correctIndex) {
                        buttonColor = Colors.green.shade100;
                        textColor = Colors.green.shade900;
                      } else if (optionIndex == state.selectedOptionIndex) {
                        buttonColor = Colors.red.shade100;
                        textColor = Colors.red.shade900;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                state.isAnswered &&
                                    optionIndex == question.correctIndex
                                ? Colors.green
                                : state.isAnswered &&
                                      optionIndex == state.selectedOptionIndex
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: state.isAnswered ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: state.isAnswered
                              ? null
                              : () {
                                  context
                                      .read<QuizCubit>()
                                      .revealAnswerWithDelay(
                                        optionIndex == question.correctIndex,
                                        optionIndex,
                                      );
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                //  Edukatív Forrás Kártya (Csak válaszadás után jelenik meg)
                // JSON fájból adja vissza
                if (state.isAnswered && question.sources != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.library_music,
                                color: Colors.blue.shade800,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tudtad? (Hiteles háttérinfó)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFBBDEFB),
                          ), // Finom elválasztó vonal
                          // Hungaroton információk
                          if (question.sources?.hungaroton != null) ...[
                            Text(
                              question.sources!.hungaroton!.catalogType ==
                                      'recording_context'
                                  ? '• Felvétel kontextus: ${question.sources!.hungaroton!.primaryPerformer ?? ""}'
                                  : '• Eredeti album: ${question.sources!.hungaroton!.title}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (question.sources!.hungaroton!.catalogType !=
                                'recording_context')
                              Text(
                                '• Kiadó: Hungaroton ${question.sources!.hungaroton!.label} (${question.sources!.hungaroton!.year})',
                                style: const TextStyle(fontSize: 14),
                              ),
                            if (question.sources!.hungaroton!.catalogType ==
                                'recording_context')
                              Text(
                                '• Megjelent: A "${question.sources!.hungaroton!.title}" című lemezen (${question.sources!.hungaroton!.year})',
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],

                          // Artisjus / ISWC kód információk
                          if (question.sources?.artisjus != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              '• Szerző(k): ${question.sources!.artisjus!.composer}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '• Hivatalos ISWC kód: ${question.sources!.artisjus!.iswc}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                // Következő kérdés gomb (Csak válaszadás után)
                if (state.isAnswered) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      context.read<QuizCubit>().goNextAfterDelay();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      state.currentQuestionIndex + 1 >= state.questions.length
                          ? 'Eredmények megtekintése'
                          : 'Következő kérdés',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
