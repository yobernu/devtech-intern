import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/domain/usecases/questions/get_questions.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_events.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final GetQuestionsByIdUsecase getQuestionsByIdUseCase;
  final GetAllQuestionsUseCase getAllQuestionsUseCase;

  QuestionsBloc({
    required this.getQuestionsByIdUseCase,
    required this.getAllQuestionsUseCase,
  }) : super(QuestionsInitialState()) {
    on<GetQuestionsEvent>(_onGetQuestions);
    on<GetQuestionsByCategoryEvent>(_onGetQuestionsByCategory);
    on<NextQuestionEvent>(_onNextQuestion);
  }

  Future<void> _onGetQuestions(
    GetQuestionsEvent event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(QuestionsLoadingState());
    final result = await getAllQuestionsUseCase.call(NoParams());

    emit(
      result.fold((failure) => QuestionsFailureState(failure), (questions) {
        final timeLimit = questions.isNotEmpty ? questions.first.timeLimit : 30;
        emit(CurrentQuestionHintState(questions.first.hint));
        return QuestionsLoadedState(
          questions: questions,
          currentQuestionIndex: 0,
          timeLength: timeLimit,
        );
      }),
    );
  }

  Future<void> _onGetQuestionsByCategory(
    GetQuestionsByCategoryEvent event,
    Emitter<QuestionsState> emit,
  ) async {
    emit(QuestionsLoadingState());
    final result = await getQuestionsByIdUseCase.call(
      GetQuestionsByIdParams(
        categoryId: event.categoryId,
        difficulty: event.difficulty,
      ),
    );
    emit(
      result.fold((failure) => QuestionsFailureState(failure), (questions) {
        final timeLimit = questions.isNotEmpty ? questions.first.timeLimit : 30;
        return QuestionsLoadedState(
          questions: questions,
          currentQuestionIndex: 0,
          timeLength: timeLimit,
        );
      }),
    );
  }

  void _onNextQuestion(NextQuestionEvent event, Emitter<QuestionsState> emit) {
    if (state is QuestionsLoadedState) {
      final loadedState = state as QuestionsLoadedState;
      final nextIndex = loadedState.currentQuestionIndex + 1;
      final currentScore = loadedState.score;
      final newScore = event.isCorrect ? currentScore + 1 : currentScore;
      final newTotalTime = loadedState.totalTimeTaken + event.timeTaken;

      if (nextIndex < loadedState.questions.length) {
        emit(
          QuestionsLoadedState(
            questions: loadedState.questions,
            currentQuestionIndex: nextIndex,
            timeLength: loadedState.questions[nextIndex].timeLimit,
            score: newScore,
            totalTimeTaken: newTotalTime,
          ),
        );
      } else {
        // Handle Quiz Finished: Navigate to results
        emit(
          QuizResultsState(
            score: newScore,
            totalQuestions: loadedState.questions.length,
            attemptedQuestions: loadedState.questions,
            totalTimeTaken: newTotalTime,
          ),
        );
      }
    }
  }
}
