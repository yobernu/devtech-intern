import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/core/constants/firebase_services.dart';
import 'package:todoapp/core/network_info.dart';
import 'package:todoapp/features/toDoListApp/data/datasources/task_remote_datasource.dart';
import 'package:todoapp/features/toDoListApp/data/datasources/tasks_local_datasource.dart';
import 'package:todoapp/features/toDoListApp/data/repositories/taskrepositoryimpl.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/add_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/delete_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/get_task.dart';
import 'package:todoapp/features/toDoListApp/domain/usecase/update_task.dart';
import 'package:todoapp/features/toDoListApp/presentation/navigation.dart';
import 'package:todoapp/features/toDoListApp/presentation/task_provider.dart';
import 'package:todoapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Shared dependencies
    final firebaseService = FirebaseService();
    final remoteDataSource = TaskRemoteDatasourceImpl(
      firebase: firebaseService,
    );
    final localDataSource = TaskLocalDataSourceImpl();
    final networkInfo = NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.createInstance(),
    );

    final taskRepository = TaskRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            addTask: AddTask(taskRepository: taskRepository),
            getTasks: GetTasks(taskRepository: taskRepository),
            updateTask: UpdateTask(taskRepository: taskRepository),
            deleteTask: DeleteTask(taskRepository: taskRepository),
          ),
        ),
        // Add more providers here as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'preahvihear',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'preahvihear'),
            displayMedium: TextStyle(fontFamily: 'preahvihear'),
            displaySmall: TextStyle(fontFamily: 'preahvihear'),
            headlineMedium: TextStyle(fontFamily: 'preahvihear'),
            headlineSmall: TextStyle(fontFamily: 'preahvihear'),
            titleLarge: TextStyle(fontFamily: 'preahvihear'),
            titleMedium: TextStyle(fontFamily: 'preahvihear'),
            titleSmall: TextStyle(fontFamily: 'preahvihear'),
            bodyLarge: TextStyle(fontFamily: 'preahvihear'),
            bodyMedium: TextStyle(fontFamily: 'preahvihear'),
            bodySmall: TextStyle(fontFamily: 'preahvihear'),
            labelLarge: TextStyle(fontFamily: 'preahvihear'),
            labelMedium: TextStyle(fontFamily: 'preahvihear'),
            labelSmall: TextStyle(fontFamily: 'preahvihear'),
          ),
        ),
      ),
    );
  }
}
