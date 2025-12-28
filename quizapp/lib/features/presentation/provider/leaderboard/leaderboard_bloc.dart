import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/features/domain/usecases/leaderboard/get_leaderboard_usecase.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_event.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

  LeaderboardBloc({required this.getLeaderboardUseCase})
    : super(LeaderboardInitial()) {
    on<FetchLeaderboardEvent>(_onFetchLeaderboard);
  }

  Future<void> _onFetchLeaderboard(
    FetchLeaderboardEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    final result = await getLeaderboardUseCase(
      GetLeaderboardParams(period: event.period),
    );

    result.fold(
      (failure) => emit(LeaderboardError(failure.message)),
      (leaderboard) => emit(LeaderboardLoaded(leaderboard: leaderboard)),
    );
  }
}
