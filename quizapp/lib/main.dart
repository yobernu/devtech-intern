import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/core/constants/auth_services.dart';
import 'package:quizapp/features/presentation/di_container.dart' as di;
import 'package:quizapp/features/presentation/navigation/navigation.dart';
import 'package:quizapp/features/presentation/provider/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before using it
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
    _sub = _appLinks.uriLinkStream.listen((Uri uri) async {
      final supabase = Supabase.instance.client;

      // Example deep link: com.quizapp://auth-callback?code=...
      if (uri.scheme == 'myapp' && uri.host == 'auth-callback') {
        try {
          // Exchange token for a session
          await supabase.auth.getSessionFromUrl(uri);

          // Navigate the user to the home page after successful verification
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login, // <-- Change if needed
              (_) => false,
            );
          }
        } catch (e) {
          debugPrint("Deep link auth error: $e");
        }
      }
    }, onError: (err) {
      debugPrint("Deep link stream error: $err");
    });
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
        initialRoute: AppRoutes.signup,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
