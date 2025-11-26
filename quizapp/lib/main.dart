import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/core/constants/auth_services.dart';
import 'package:quizapp/features/presentation/di_container.dart' as di;
import 'package:quizapp/features/presentation/navigation/navigation.dart';
import 'package:quizapp/features/presentation/provider/auth/auth_bloc.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/provider/questions/questions_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AuthService.supabaseUrl,
    anonKey: AuthService.supabaseAnonKey,
  );

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        final supabase = Supabase.instance.client;
        if (uri.scheme == 'myapp' && uri.host == 'auth-callback') {
          try {
            await supabase.auth.getSessionFromUrl(uri);
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            }
          } catch (e) {
            debugPrint("Deep link auth error: $e");
          }
        }
      },
      onError: (err) {
        debugPrint("Deep link stream error: $err");
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<QuestionsBloc>()),
        BlocProvider(create: (_) => di.sl<CategoriesBloc>()),
      ],
      child: MaterialApp(
        title: 'Quiz App UI',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppColors.surfaceWhite,
        ),
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.home,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
