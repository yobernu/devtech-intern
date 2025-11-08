import 'package:dartz/dartz.dart';
import 'package:quizapp/core/errors/failures.dart';
import 'package:quizapp/core/usecases.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';

class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final UserRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}
