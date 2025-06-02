import 'package:diainfo/features/auth/auth.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Diainfo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A74DA),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              const Text('Olá, ', style: TextStyle(fontSize: 16)),
              Text(
                Auth().currentUser?.displayName ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 6),
              const CircleAvatar(
                radius: 16,
                // backgroundImage: AssetImage('avatar.png'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
