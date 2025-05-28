import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:flutter/material.dart';

class CheckupScreen extends StatelessWidget {
  const CheckupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          final routes = [
            '/dashboard',
            '/map',
            '/glicemia',
            '/checkup',
            '/profile',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }
}
