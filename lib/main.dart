import 'package:diainfo/features/dashboard/screens/dashboard/dashboard_screen.dart';
import 'package:diainfo/features/auth/screens/login/login_screen.dart';
import 'package:diainfo/features/auth/screens/recoverypass/recoverypass_screen.dart';
import 'package:diainfo/features/auth/screens/signup/signup_screen.dart';
import 'package:diainfo/features/auth/screens/glicemia/glicemia_screen.dart';
import 'package:diainfo/features/auth/screens/Profile/profile_screen.dart';
import 'package:diainfo/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diainfo',
      theme: AppTheme.lightTheme,
      home: SignupScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/recoverypass': (context) => RecoverypassScreen(),
        '/profile': (context) => ProfileScreen(),
        '/glicemia': (context) => GlicemiaScreen(),
      },
    );
  }
}
