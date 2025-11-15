import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';
import 'package:quizapp/features/auth/domain/usecases/auth_status_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/get_currentuser.dart';
import 'package:quizapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/refresh_token_usecase.dart'; // ADDED
import 'package:quizapp/features/auth/domain/usecases/signout_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:quizapp/features/presentation/provider/auth_event.dart';
import 'package:quizapp/features/presentation/provider/auth_state.dart';

class AuthBloc extends Bloc<UserEvent, UserState> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final RefreshTokenUsecase refreshTokenUseCase; // ADDED
  final InternetConnectionChecker connectionChecker;

  // Supabase tokens expire after 60 mins (3600s). We refresh preemptively.
  static const Duration _sessionDuration = Duration(minutes: 55);

  UserEntity? _currentUser;
  Timer? sessionTimer;

  AuthBloc({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
    required this.connectionChecker,
    required this.refreshTokenUseCase, // ADDED
  }) : super(UserInitialState()) {
    // The event handler signature must match Emitter signature
    on<SignUpRequestedEvent>(_onSignup);
    on<LogInRequestedEvent>(_onLogin);
    on<SignOutRequestedEvent>(_onSignOut);
    on<CheckAuthenticationStatusEvent>(_onCheckAuthStatus);
    on<RefreshTokenEvent>(_onRefreshToken);
  }

  // --- Session Management ---

  void _startSessionTimer() {
    // Cancel any existing timer before starting a new one
    sessionTimer?.cancel();

    // Start a new timer that dispatches a RefreshTokenEvent every 55 minutes
    sessionTimer = Timer.periodic(_sessionDuration, (timer) {
      add(RefreshTokenEvent());
    });
  }

  void _cancelSessionTimer() {
    sessionTimer?.cancel();
    sessionTimer = null;
  }

  // Ensure the timer is cancelled when the BLoC is closed
  @override
  Future<void> close() {
    _cancelSessionTimer();
    return super.close();
  }

  // --- Event Handlers ---

  Future<void> _onSignup(
    // Corrected to match registered handler name
    SignUpRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());

      // Access connectionChecker from the class instance
      if (!await connectionChecker.hasConnection) {
        emit(UserFailureState(ServerFailure('No internet connection')));
        return;
      }

      final result = await signUpUseCase(
        SignupUParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      result.fold((failure) => emit(UserFailureState(failure)), (user) {
        _currentUser = user;
        emit(UserSignUpSuccessState(user));
        // Start the session timer after successful sign up
        _startSessionTimer();
      });
    } catch (e) {
      emit(UserFailureState(ServerFailure('An unexpected error occurred: $e')));
    }
  }

  Future<void> _onLogin(
    LogInRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());
    final params = LoginParams(email: event.email, password: event.password);
    final result = await loginUseCase.call(params);
    emit(
      result.fold((failure) => UserFailureState(failure), (user) {
        _currentUser = user;
        // Start the session timer after successful login
        _startSessionTimer();
        return UserLogInSuccessState(user);
      }),
    );
  }

  Future<void> _onSignOut(
    SignOutRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());
    final result = await signOutUseCase.call(NoParams());
    emit(
      result.fold((failure) => UserFailureState(failure), (user) {
        _cancelSessionTimer(); // Cancel the timer on sign out
        _currentUser = null;
        return UserSignedOutState();
      }),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthenticationStatusEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    // First check if user is authenticated
    final authResult = await checkAuthStatusUseCase.call(NoParams());

    await authResult.fold(
      (failure) async {
        emit(UserFailureState(failure));
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          // If authenticated, get the current user
          final userResult = await getCurrentUserUseCase.call(NoParams());
          userResult.fold((failure) => emit(UserFailureState(failure)), (user) {
            _currentUser = user;
            _startSessionTimer();
            emit(UserAuthenticatedState(user));
          });
        } else {
          emit(UserUnauthenticatedState());
        }
      },
    );
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<UserState> emit,
  ) async {
    // Note: Do not emit UserLoadingState here to avoid constant UI flicker
    // just before the token is refreshed.

    final result = await refreshTokenUseCase.call(NoParams());
    emit(
      result.fold(
        (failure) {
          // If refresh fails, sign the user out (or emit a generic failure)
          _cancelSessionTimer();
          // We can't use UserFailureState here as it's not severe enough to block UI,
          // but we might want to prompt a login later. For now, we'll try to keep
          // the last known state, or emit a quiet failure.
          // For stability, we emit failure and let the UI handle it.
          return UserFailureState(failure);
        },
        (user) {
          _currentUser = user;
          // Restart the timer after a successful refresh
          _startSessionTimer();
          // A successful refresh means the user is still authenticated
          return UserAuthenticatedState(user);
        },
      ),
    );
  }
}
