import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage = '';
  bool _isLoading = false;

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/tree');
    } on FirebaseAuthException {
      _showMessage('Email ou senha incorretos');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.redAccent),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe seu email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem
          Positioned.fill(
            child: Image.asset(
              'assets/signup-background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: appDefaultSize,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: Column(
                          children: [
                            Image.asset('assets/diainfo-logo.png', height: 100),
                            Text(
                              "Dianfo",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A74DA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              validator: _validateSenha,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Esqueceu sua senha? '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/recoverypass',
                                    );
                                  },
                                  child: const Text(
                                    'Toque Aqui',
                                    style: TextStyle(
                                      color: Color(0xFF4A74DA),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: appButtonHeight,
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading
                                        ? null
                                        : signInWithEmailAndPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A74DA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          'Entrar',
                                          style: TextStyle(fontSize: 16),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Espaço para empurrar o "cadastre-se" para baixo
                      const Spacer(),
                      // Texto "cadastre-se"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Ainda não possui conta? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                color: Color(0xFF4A74DA),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
