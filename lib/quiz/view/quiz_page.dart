import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:quiz/quiz/cubit/quiz_cubit.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';
import 'package:quiz/quiz/view/result_view.dart';
import 'package:quiz/quiz/view/widgets/options_list.dart';
import 'package:quiz/quiz/view/widgets/question_card.dart';
import 'package:quiz/quiz/view/widgets/quiz_header.dart';
import 'package:quiz/quiz/view/widgets/source_card.dart';
import 'package:quiz/quiz/view/widgets/welcome_screen.dart';

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

// UI
class _QuizView extends StatelessWidget {
  const _QuizView();

  static const Color _bgColor = Color(0xFF101217);
  static const Color _cardColor = Color(0xFF1F2332);
  static const Color _accentColor = Color(0xFFFFC107);
  static const Color _contentText = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          'Magyar Rock Kvíz',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _accentColor),
            );
          }
          //
          if (state.isFinished) {
            return ResultView(score: state.score);
          }
          //
          if (state.isDifficultyPage) {
            return _buildDifficultyScreen(context);
          }
          //
          if (state.isWelcomePage) {
            return WelcomeScreen(
              onStart: () {
                context.read<QuizCubit>().goToDifficultySelection();
              },
            );
          }

          if (state.questions.isEmpty) {
            return const Center(
              child: Text(
                'Nincs elérhető kérdés ezen a szinten.',
                style: TextStyle(color: _contentText, fontSize: 16),
              ),
            );
          }

          final question = state.questions[state.currentQuestionIndex];

          return SizedBox(
            // Kényszerítés a teljes szélességre
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                // Egységes kinézet
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizHeader(
                    currentQuestion: state.currentQuestionIndex + 1,
                    totalQuestions: state.questions.length,
                    score: state.score,
                  ),
                  const SizedBox(height: 32),

                  QuestionCard(question: question),
                  const SizedBox(height: 28),

                  OptionsList(
                    question: question,
                    isAnswered: state.isAnswered,
                    selectedOptionIndex: state.selectedOptionIndex,
                  ),

                  if (state.isAnswered && question.sources != null) ...[
                    const SizedBox(height: 24),
                    SourceCard(question: question),
                  ],

                  if (state.isAnswered) ...[
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        // A következő kérdésre lépés késleltetéssel, hogy a felhasználó láthassa az eredményt
                        //vissza kell jönni ide
                        context.read<QuizCubit>().goNextAfterDelay();
                      },
                      icon: const Icon(LucideIcons.arrowRight, size: 20),
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
            ),
          );
        },
      ),
    );
  }

  //Nehézségi szint választó képernyő
  Widget _buildDifficultyScreen(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Válassz nehézségi szintet!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Készülj fel, az extrém szint igazi mélyvíz!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 48),
              // Nehézségi gombok
              _buildDifficultyButton(
                context,
                label: 'Könnyű Rocker',
                difficultyKey: 'easy',
                color: Colors.green.shade400,
              ),
              const SizedBox(height: 20),
              _buildDifficultyButton(
                context,
                label: 'Haladó Gitáros',
                difficultyKey: 'medium',
                color: Colors.orange.shade400,
              ),
              const SizedBox(height: 20),
              _buildDifficultyButton(
                context,
                label: 'Extrém Rocklegenda ',
                difficultyKey: 'extreme',
                color: const Color.fromARGB(255, 205, 16, 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Közös gombépítés a nehézségi szintekhez
  Widget _buildDifficultyButton(
    BuildContext context, {
    required String label,
    required String difficultyKey,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _cardColor,
          foregroundColor: Colors.white,
          side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () =>
            context.read<QuizCubit>().selectDifficultyAndStart(difficultyKey),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
