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

  /// Színpaletta a kvízhez: sötét háttér, kontrasztos kártyák és élénk színek
  /// Visszatalálni ide változtatáshoz.
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

          if (state.isWelcomePage) {
            return _buildWelcomeScreen(context, state.questions.length);
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
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      'Pontszám: ${state.score}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value:
                      (state.currentQuestionIndex + 1) / state.questions.length,
                  backgroundColor: const Color(0xFF171A24),
                  valueColor: const AlwaysStoppedAnimation<Color>(_accentColor),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 24),

                // Kérdés kártya
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    key: ValueKey<String>(question.id),
                    color: _cardColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

                    Color buttonColor = _cardColor;
                    Color textColor = _contentText;
                    Color borderColor = const Color(0xFF2A2F41);

                    if (state.isAnswered) {
                      if (optionIndex == question.correctIndex) {
                        buttonColor = Colors.green.shade900.withOpacity(0.4);
                        textColor = Colors.green.shade200;
                        borderColor = Colors.green;
                      } else if (optionIndex == state.selectedOptionIndex) {
                        buttonColor = Colors.red.shade900.withOpacity(0.4);
                        textColor = Colors.red.shade200;
                        borderColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: state.isAnswered ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                color: state.isAnswered
                                    ? textColor
                                    : _contentText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Edukatív Forrás Kártya
                if (state.isAnswered && question.sources != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: _accentColor.withOpacity(0.16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _accentColor.withOpacity(0.35),
                      ),
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
                                color: _accentColor.withOpacity(0.95),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tudtad? (Hiteles háttérinfó)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _accentColor.withOpacity(0.95),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24),
                          if (question.sources?.hungaroton != null) ...[
                            Text(
                              question.sources!.hungaroton!.catalogType ==
                                      'recording_context'
                                  ? '• Felvétel kontextus: ${question.sources!.hungaroton!.primaryPerformer ?? ""}'
                                  : '• Eredeti album: ${question.sources!.hungaroton!.title}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (question.sources!.hungaroton!.catalogType !=
                                'recording_context')
                              Text(
                                '• Kiadó: Hungaroton ${question.sources!.hungaroton!.label} (${question.sources!.hungaroton!.year})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            if (question.sources!.hungaroton!.catalogType ==
                                'recording_context')
                              Text(
                                '• Megjelent: A "${question.sources!.hungaroton!.title}" című lemezen (${question.sources!.hungaroton!.year})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                          ],
                          if (question.sources?.artisjus != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              '• Szerző(k): ${question.sources!.artisjus!.composer}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '• Hivatalos ISWC kód: ${question.sources!.artisjus!.iswc}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                // Manuális "Következő kérdés" gomb
                if (state.isAnswered) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      context.read<QuizCubit>().goNextAfterDelay();
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      // fontWeight not valid for Icon; using default.
                    ),
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

  // 🔥 KIMAGASLÓAN SZEBB ÉS MODERNEBB KEZDŐLAP (WELCOME SCREEN)
  Widget _buildWelcomeScreen(BuildContext context, int questionCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // Nagyméretű dizájnos Rock ikon kör alakú háttérrel és parázs/arany effektussal
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: _accentColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.bolt, // Villám / Rock ikon
              size: 80,
              color: _accentColor,
            ),
          ),
          const SizedBox(height: 40),

          // Főcím stílusos betűközzel és vastagsággal
          const Text(
            'Magyar Rock Kvíz',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Alcím / Leírás
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Teszteld a tudásod a hazai rocktörténelem legnagyobb slágereiről, albumairól és legendáiról!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade400,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Kis modern "Badge" a kérdések számának kiemelésére
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E24),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.help_outline, color: _accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$questionCount kérdés vár rád',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Prémium kinézetű indítógomb
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              onPressed: () {
                context.read<QuizCubit>().startQuiz();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kvíz Indítása',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow_rounded, size: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
