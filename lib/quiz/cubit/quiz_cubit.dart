import 'package:bloc/bloc.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

// Cubit a quiz állapotának kezelésére
class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repository;

  QuizCubit(QuizRepository repository)
    : _repository = repository,
      super(QuizState.initial());

  Future<void> loadQuiz() async {
    final rawQuestions = await _repository.loadQuestions();
    final shuffledQuestions = List.of(rawQuestions)..shuffle();

    emit(
      state.copyWith(
        questions: shuffledQuestions,
        isLoading: false,
      ),
    );
  }

  // Kezdőképernyő,
  void startQuiz() {
    emit(state.copyWith(isWelcomePage: false));
  }

  void answer(bool isCorrect, int selectedOptionIndex) {
    emit(
      state.copyWith(
        isAnswered: true,
        wasCorrect: isCorrect,
        score: isCorrect ? state.score + 1 : state.score,
        selectedOptionIndex: selectedOptionIndex,
      ),
    );
  }

  // Vár egy rövid időt, majd megmutatja, hogy a válasz helyes volt-e.
  // Ez létrehoz egy késleltetés  a felhasználói élményhez.
  Future<void> revealAnswerWithDelay(
    bool isCorrect,
    int selectedOptionIndex, {
    int revealMilliseconds = 500,
  }) async {
    await Future<void>.delayed(Duration(milliseconds: revealMilliseconds));
    answer(isCorrect, selectedOptionIndex);
  }

  // Vár egy rövid időt, majd megmutatja a következő kérdést, vagy ha már nincs több kérdés, akkor véget ér a játék.
  Future<void> goNextAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final nextIndex = state.currentQuestionIndex + 1;

    if (nextIndex >= state.questions.length) {
      emit(state.copyWith(isFinished: true));
      return;
    }

    emit(
      state.copyWith(
        currentQuestionIndex: nextIndex,
        isAnswered: false,
        wasCorrect: null,
        selectedOptionIndex: null,
      ),
    );
  }

  void restart() {
    // Újraindításkor visszajövünk a kezdőlapra, hogy újra lehessen indítani
    emit(QuizState.initial().copyWith(isLoading: true, isWelcomePage: true));
    loadQuiz();
  }
}
