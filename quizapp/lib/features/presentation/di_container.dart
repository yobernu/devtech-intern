import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quizapp/features/auth/data/repository/repository_impl.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';
import 'package:quizapp/features/auth/domain/usecases/auth_status_usecase.dart';

import 'package:quizapp/features/auth/domain/usecases/get_currentuser.dart';
import 'package:quizapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/signup_usecase.dart';

import 'package:quizapp/features/auth/domain/usecases/signout_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/refresh_token_usecase.dart';

import 'package:quizapp/features/presentation/provider/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      connectionChecker: sl(),
      refreshTokenUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl())); // NEW
  sl.registerLazySingleton(() => RefreshTokenUsecase(sl())); // NEW
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl())); // NEW
  // sl.registerLazySingleton(() => UpdatePasswordUseCase(sl())); // NEW
  // sl.registerLazySingleton(() => UpdateProfileUseCase(sl())); // NEW
  // sl.registerLazySingleton(() => UpdateProfilePictureUseCase(sl())); // NEW
  // sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl())); // NEW

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => RepositoryImpl(
      sl<RemoteAuthDataSource>(),
      sl<NetworkInfo>(),
      client: sl<http.Client>(),
    ),
  );

  sl.registerLazySingleton<RemoteAuthDataSource>(
    () => AuthRemoteDataSourceImpl(sl<http.Client>()),
  );
}
