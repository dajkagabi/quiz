import 'package:bloc/bloc.dart';
import 'package:quiz/quiz/cubit/quiz_state.dart';
import 'package:quiz/quiz/models/question.dart';
import 'package:quiz/quiz/repository/quiz_repository.dart';

// Cubit a quiz állapotának kezelésére
class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repository;
  List<Question> _allRawQuestions = []; // Eredeti lista tárolása

  QuizCubit(QuizRepository repository)
    : _repository = repository,
      super(QuizState.initial());

  Future<void> loadQuiz() async {
    _allRawQuestions = await _repository.loadQuestions();
    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

  // A kezdőlapról a nehézség választóra lépünk
  void goToDifficultySelection() {
    emit(
      state.copyWith(
        isWelcomePage: false,
        isDifficultyPage: true,
      ),
    );
  }

  // Kiválasztjuk a nehézséget, kiszűrjük a listát, megkeverjük és indítunk
  void selectDifficultyAndStart(String difficulty) {
    final filteredQuestions = _allRawQuestions
        .where((q) => q.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();

    final shuffledQuestions = List.of(filteredQuestions)..shuffle();

    emit(
      state.copyWith(
        questions: shuffledQuestions,
        selectedDifficulty: difficulty,
        isDifficultyPage: false,
      ),
    );
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

  Future<void> revealAnswerWithDelay(
    bool isCorrect,
    int selectedOptionIndex, {
    int revealMilliseconds = 500,
  }) async {
    await Future<void>.delayed(Duration(milliseconds: revealMilliseconds));
    answer(isCorrect, selectedOptionIndex);
  }

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
    emit(QuizState.initial().copyWith(isLoading: true, isWelcomePage: true));
    loadQuiz();
  }
}
