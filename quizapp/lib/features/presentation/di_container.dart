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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Use cases -- auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl())); // NEW
  sl.registerLazySingleton(() => RefreshTokenUsecase(sl())); // NEW
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl())); // NEW

  // usecases -- questions bloc
  sl.registerLazySingleton(() => GetQuestionsByIdUsecase(sl()));
  sl.registerLazySingleton(() => GetAllQuestionsUseCase(sl()));

  // usecases -- category bloc
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoryNameByIdUsecase(sl()));

  // auth -- Repository
  sl.registerLazySingleton<UserRepository>(
    () => RepositoryImpl(
      sl<RemoteAuthDataSource>(),
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
}
