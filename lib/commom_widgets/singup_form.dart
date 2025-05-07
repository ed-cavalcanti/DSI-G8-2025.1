import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/auth/models/user.dart';
import 'package:diainfo/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SingupForm extends StatelessWidget {
  const SingupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final authService = AuthService();

    String? name;
    String? email;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: appFormHeight - 10),
      margin: EdgeInsets.only(top: 20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text("Nome"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.user(PhosphorIconsStyle.bold),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                name = value;
                return null;
              },
            ),
            const SizedBox(height: appFormHeight - 10),
            TextFormField(
              decoration: InputDecoration(
                label: Text("E-mail"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.envelopeSimple(PhosphorIconsStyle.bold),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu e-mail';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                  return 'Por favor, insira um e-mail válido';
                }
                email = value;
                return null;
              },
            ),
            const SizedBox(height: appFormHeight - 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                label: Text("Senha"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.fingerprintSimple(PhosphorIconsStyle.bold),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: appFormHeight - 10),
            TextFormField(
              decoration: InputDecoration(
                label: Text("Confirmar senha"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.fingerprintSimple(PhosphorIconsStyle.bold),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, confirme sua senha';
                }
                if (value != passwordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
            const SizedBox(height: 160.0),
            SizedBox(
              width: double.infinity,
              height: appButtonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    final user = User(
                      name: name!,
                      email: email!,
                      password: passwordController.text,
                    );

                    final success = await authService.signup(user);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cadastro realizado com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pushNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('E-mail já cadastrado!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
