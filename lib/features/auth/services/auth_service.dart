import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  Future<bool> signup(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString('users') ?? '{}';
    final Map<String, dynamic> users = jsonDecode(usersData);

    if (users.containsKey(user.email)) {
      return false; // Usuário já existe
    }

    users[user.email] = user.toJson();
    await prefs.setString('users', jsonEncode(users));
    return true; // Cadastro concluído
  }
}
