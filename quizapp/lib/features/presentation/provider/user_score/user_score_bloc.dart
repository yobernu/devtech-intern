import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/features/domain/usecases/leaderboard/get_user_score.dart';
import 'package:quizapp/features/presentation/provider/user_score/user_score_event.dart';
import 'package:quizapp/features/presentation/provider/user_score/user_score_state.dart';

class UserScoreBloc extends Bloc<UserScoreEvent, UserScoreState> {
  final GetUserScoreUseCase getUserScoreUseCase;

  UserScoreBloc({required this.getUserScoreUseCase})
    : super(const UserScoreInitial()) {
    on<GetUserScoreEvent>(_onGetUserScore);
  }

  Future<void> _onGetUserScore(
    GetUserScoreEvent event,
    Emitter<UserScoreState> emit,
  ) async {
    emit(const UserScoreLoading());

    final result = await getUserScoreUseCase(const GetUserScoreParams());

    result.fold(
      (failure) => emit(UserScoreError(failure)),
      (score) => emit(UserScoreLoaded(score)),
    );
  }
}
