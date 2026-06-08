import 'package:bloc/bloc.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

// Cubit a quiz állapotának kezelésére
// A QuizCubit osztály a quiz állapotát kezeli, beleértve akérdések betöltését, a következő kérdésre lépést, a válaszok értékelését és a kvíz újraindítását.
// A QuizRepository-t használja a kérdések betöltésére.

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository repository;

  QuizCubit(this.repository) : super(QuizState.initial());

  Future<void> loadQuiz() async {
    final questions = await repository.loadQuestions();

    emit(
      state.copyWith(
        questions: questions,
        isLoading: false,
      ),
    );
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
        state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
        ),
      );
    } else {
      emit(state.copyWith(isFinished: true));
    }
  }

  void answer(bool isCorrect) {
    if (isCorrect) {
      emit(
        state.copyWith(score: state.score + 1),
      );
    }
  }

  void restart() {
    emit(
      state.copyWith(
        questions: state.questions,
        currentQuestionIndex: 0,
        score: 0,
        isFinished: false,
      ),
    );
  }
}
