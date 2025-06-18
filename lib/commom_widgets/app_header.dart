import 'package:diainfo/commom_widgets/user_avatar.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(30),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(left: 24, top: 54, right: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/diainfo-logo.png", height: 50),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            borderRadius: BorderRadius.circular(30),
            child: Row(
              children: [
                const Text('Olá, ', style: TextStyle(fontSize: 16)),
                Text(
                  user?.displayName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const CurrentUserAvatar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
