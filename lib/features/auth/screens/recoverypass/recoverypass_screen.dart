
import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoverypassScreen extends StatefulWidget {
  const RecoverypassScreen({super.key});

  @override
  State<RecoverypassScreen> createState() => _RecoverypassScreenState();
}

class _RecoverypassScreenState extends State<RecoverypassScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> handleResetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showSnackbar('Por favor, insira um e-mail.', Colors.red);
      return;
    }

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackbar(
        'E-mail de recuperação enviado. Verifique sua caixa de entrada.',
        Colors.green,
      );
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar('E-mail não encontrado.', Colors.red);
      } else if (e.code == 'invalid-email') {
        showSnackbar('Formato de e-mail inválido.', Colors.red);
      } else {
        showSnackbar('Erro: ${e.message}', Colors.red);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                'assets/signup-background.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(appDefaultSize),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: "Recuperar senha",
                      navigateBack: "/login",
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Digite seu e-mail para recuperação de senha:',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleResetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A74DA),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}