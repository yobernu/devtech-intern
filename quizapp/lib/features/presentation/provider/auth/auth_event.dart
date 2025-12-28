import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequestedEvent extends UserEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class LogInRequestedEvent extends UserEvent {
  final String email;
  final String password;

  const LogInRequestedEvent({required this.email, required this.password});

  Map<String, dynamic> get params => {'email': email, 'password': password};
}

class SignOutRequestedEvent extends UserEvent {
  final String userId;

  const SignOutRequestedEvent({required this.userId});

  Map<String, dynamic> get params => {'userId': userId};
}

class CheckAuthenticationStatusEvent extends UserEvent {}

class RefreshTokenEvent extends UserEvent {}

class UpdateUserScoreEvent extends UserEvent {
  final int score;

  const UpdateUserScoreEvent({required this.score});

  @override
  List<Object> get props => [score];
}

class GoogleSignInRequestedEvent extends UserEvent {}

class PhoneSignInRequestedEvent extends UserEvent {
  final String phoneNumber;

  const PhoneSignInRequestedEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpRequestedEvent extends UserEvent {
  final String phone;
  final String token;

  const VerifyOtpRequestedEvent({required this.phone, required this.token});

  @override
  List<Object> get props => [phone, token];
}
