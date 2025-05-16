import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/features/auth/screens/login/login_screen.dart';
import 'package:diainfo/features/dashboard/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class Tree extends StatefulWidget {
  const Tree({super.key});

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
