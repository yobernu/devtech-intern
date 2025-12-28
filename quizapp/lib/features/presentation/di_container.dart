import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quizapp/core/network_info.dart';
import 'package:quizapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:quizapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quizapp/features/auth/data/repository/repository_impl.dart';
import 'package:quizapp/features/auth/domain/repositories/user_repositories.dart';
import 'package:quizapp/features/auth/domain/usecases/auth_status_usecase.dart';

import 'package:quizapp/features/auth/domain/usecases/get_currentuser.dart';
import 'package:quizapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/signup_usecase.dart';

import 'package:quizapp/features/auth/domain/usecases/signout_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/update_user_score_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/phone_sign_in_usecase.dart';
import 'package:quizapp/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:quizapp/features/data/datasources/localdatasources/local_categories_datasources.dart';
import 'package:quizapp/features/data/datasources/localdatasources/local_quiz_datasources.dart';
import 'package:quizapp/features/data/datasources/remote_datasource/remote_categories_datasource.dart';
import 'package:quizapp/features/data/datasources/remote_datasource/remote_quiz_repository_datasource.dart';
import 'package:quizapp/features/data/repository_implementation.dart/categories_repository.dart';
import 'package:quizapp/features/data/repository_implementation.dart/quiz_repository_repository_implementation.dart';
import 'package:quizapp/features/domain/repositories/repositories.dart'
    hide UserRepository;
import 'package:quizapp/features/domain/usecases/questions/get_categories_usecase.dart';
import 'package:quizapp/features/domain/usecases/questions/get_categorynamebyid.dart';
import 'package:quizapp/features/domain/usecases/questions/get_questions.dart';

import 'package:quizapp/features/presentation/provider/auth/auth_bloc.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_bloc.dart';
import 'package:quizapp/features/presentation/provider/user_score/user_score_bloc.dart';
import 'package:quizapp/features/presentation/provider/leaderboard/leaderboard_bloc.dart';
import 'package:quizapp/features/domain/usecases/leaderboard/get_leaderboard_usecase.dart';
import 'package:quizapp/features/domain/usecases/leaderboard/get_user_score.dart';
import 'package:quizapp/features/domain/repositories/leaderboard_repository.dart';
import 'package:quizapp/features/data/repository_implementation.dart/leaderboard_repository_impl.dart';
import 'package:quizapp/features/data/datasources/remote_datasource/leaderboard_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../xo_game/data/datasources/xo_local_datasource.dart';
import '../xo_game/data/repositories/xo_repository_impl.dart';
import '../xo_game/domain/repositories/xo_repository.dart';
import '../xo_game/presentation/bloc/xo_game_bloc.dart';

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
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      connectionChecker: sl(),
      refreshTokenUseCase: sl(),
      updateUserScoreUseCase: sl(),
      googleSignInUseCase: sl(),
      phoneSignInUseCase: sl(),
      verifyOtpUseCase: sl(),
    ),
  );

  // Questions -- bloc
  sl.registerFactory(
    () => QuestionsBloc(
      getAllQuestionsUseCase: sl(),
      getQuestionsByIdUseCase: sl(),
    ),
  );

  // categories -- bloc
  sl.registerFactory(
    () => CategoriesBloc(
      getCategoriesUsecase: sl(),
      getCategoryNameByIdUsecase: sl(),
    ),
  );

  // user score -- bloc
  sl.registerFactory(() => UserScoreBloc(getUserScoreUseCase: sl()));

  // Use cases -- auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl())); // NEW
  sl.registerLazySingleton(() => RefreshTokenUsecase(sl())); // NEW
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl())); // NEW
  sl.registerLazySingleton(() => UpdateUserScoreUseCase(sl())); // NEW
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => PhoneSignInUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // usecases -- questions bloc
  sl.registerLazySingleton(() => GetQuestionsByIdUsecase(sl()));
  sl.registerLazySingleton(() => GetAllQuestionsUseCase(sl()));

  // usecases -- category bloc
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoryNameByIdUsecase(sl()));

  // usecases -- user score
  sl.registerLazySingleton(() => GetUserScoreUseCase(sl()));

  // auth -- Repository
  sl.registerLazySingleton<UserRepository>(
    () => RepositoryImpl(
      sl<RemoteAuthDataSource>(),
      sl<LocalAuthDataSource>(),
      sl<NetworkInfo>(),
      client: sl<http.Client>(),
    ),
  );

  // questions -- Repository
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      sl<RemoteQuizDataSource>(),
      sl<LocalQuizDatasources>(),
      sl<NetworkInfo>(),
    ),
  );

  // categories -- Repository
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      sl<RemoteCategoriesDatasource>(),
      sl<LocalCategoriesDatasources>(),
      sl<NetworkInfo>(),
    ),
  );

  // datasources - remote
  sl.registerLazySingleton<RemoteAuthDataSource>(
    () => AuthRemoteDataSourceImpl(sl<http.Client>()),
  );

  // datasources - local - auth
  sl.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<RemoteQuizDataSource>(
    () => RemoteQuizDataSourceImpl(sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<RemoteCategoriesDatasource>(
    () => RemoteCategoriesDatasourceImpl(sl<SupabaseClient>()),
  );

  // datasources - local
  sl.registerLazySingleton<LocalCategoriesDatasources>(
    () => LocalCategoriesDataSourcesImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<LocalQuizDatasources>(
    () => LocalQuizDataSourcesImpl(sl<SharedPreferences>()),
  );

  // X/O Game
  sl.registerLazySingleton<XoLocalDatasource>(
    () => XoLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<XoRepository>(
    () => XoRepositoryImpl(localDatasource: sl()),
  );
  sl.registerFactory(() => XoGameBloc(repository: sl()));

  // Leaderboard -- bloc
  sl.registerFactory(() => LeaderboardBloc(getLeaderboardUseCase: sl()));

  // usecases -- leaderboard
  sl.registerLazySingleton(() => GetLeaderboardUseCase(sl()));

  // leaderboard -- Repository
  sl.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // datasources - remote - leaderboard
  sl.registerLazySingleton<LeaderboardRemoteDataSource>(
    () => LeaderboardRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
}
