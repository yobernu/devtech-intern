import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/features/auth/domain/entity/user_entity.dart';

abstract class UserState {}

class UserInitialState extends UserState {
  UserInitialState();
}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final UserEntity user;

  UserSuccessState(this.user);
}

class UserSignUpSuccessState extends UserState {
  final UserEntity user;
  UserSignUpSuccessState(this.user);
}

class UserLogInSuccessState extends UserState {
  final UserEntity user;
  UserLogInSuccessState(this.user);
}

class UserLoggedInState extends UserState {
  final UserEntity user;

  UserLoggedInState(this.user);
}

class UserTokenRefreshFailedState extends UserState {
  final String message;
  UserTokenRefreshFailedState(this.message);
}

class UserSignedOutState extends UserState {}

class UserAuthenticatedState extends UserState {
  final UserEntity user;

  UserAuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UserUnauthenticatedState extends UserState {}

class UserFailureState extends UserState {
  final Failure failure;

  UserFailureState(this.failure);
}
