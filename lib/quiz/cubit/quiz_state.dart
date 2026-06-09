import 'package:quiz/quiz/models/question.dart';

// A kvíz aktuális állapotát tárolja.
// Ez az osztály tartalmazza a betöltött kérdéseket, az aktuális kérdés indexét,
// a jelenlegi pontszámot, és azt, hogy jelenleg töltődik-e a kvíz, illetve
// véget ért-e már a játék.
class QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;
  final bool isLoading;
  final bool isFinished;
  final bool isAnswered;
  final bool? wasCorrect;
  final int? selectedOptionIndex;
  final bool isWelcomePage;

  const QuizState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.isLoading,
    required this.isFinished,
    required this.isAnswered,
    required this.wasCorrect,
    required this.selectedOptionIndex,
    required this.isWelcomePage,
  });

  factory QuizState.initial() {
    return const QuizState(
      questions: [],
      currentQuestionIndex: 0,
      score: 0,
      isLoading: true,
      isFinished: false,
      isAnswered: false,
      wasCorrect: null,
      selectedOptionIndex: null,
      isWelcomePage: true,
    );
  }

  QuizState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? score,
    bool? isLoading,
    bool? isFinished,
    bool? isAnswered,
    bool? wasCorrect,
    int? selectedOptionIndex,
    bool? isWelcomePage,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
      isAnswered: isAnswered ?? this.isAnswered,
      wasCorrect: wasCorrect ?? this.wasCorrect,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isWelcomePage: isWelcomePage ?? this.isWelcomePage,
    );
  }
}
