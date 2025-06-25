import 'package:diainfo/commom_widgets/user_avatar.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;

    final String firstName = user?.displayName?.split(' ').first ?? '';
    final String displayName =
        (firstName.length <= 20 && firstName.isNotEmpty)
            ? firstName
            : 'Usuário';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 236, 255),
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
            onTap: () async {
              await Navigator.pushNamed(context, '/profile');
              // Atualiza o header quando retorna da tela de perfil
              setState(() {});
            },
            borderRadius: BorderRadius.circular(30),
            child: Row(
              children: [
                const Text('Olá, ', style: TextStyle(fontSize: 16)),
                Text(
                  displayName,
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
