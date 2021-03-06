
import 'package:bianca/pages/scanner.dart';
import 'package:bianca/pages/home.dart';
import 'package:bianca/pages/login.dart';
import 'package:bianca/pages/splash.dart';
import 'package:bianca/providers/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bianca/pages/onboarding.dart';
import 'package:bianca/pages/signup.dart';
import 'package:provider/provider.dart';

import 'colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      builder: (context, _) => const App(),
    )
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> with WidgetsBindingObserver{
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bianca',
      navigatorKey: _navigator,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.dark(
            background: AppColors.primaryDark,
            onBackground: AppColors.primaryDark,
            surface: AppColors.primaryDark,
            secondary: AppColors.primaryDark,
            primary: AppColors.accent,
          ),
          backgroundColor: AppColors.primaryDark,
          fontFamily: 'Montserrat'
      ),
      onGenerateRoute: (settings) {
        if (settings.name == "/splash") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const SplashPage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

        if (settings.name == "/login") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const LoginPage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

        if (settings.name == "/signup") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const SignUpPage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

        if (settings.name == "/onboarding") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const OnboardingPage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

        if (settings.name == "/scanner") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const ScannerPage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

        if (settings.name == "/home") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (a,b,c) => const HomePage(),
              transitionsBuilder: (a,b,c,d) => FadeTransition(opacity: b, child: d),
              transitionDuration: const Duration(milliseconds: 250)
          );
        }

      },
      initialRoute: '/splash',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
}