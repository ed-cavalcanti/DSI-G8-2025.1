import 'dart:developer';

import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adicionar esta importação
import 'package:flutter/material.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final Auth _auth = Auth();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.changePassword(
          currentPassword: _currentPassController.text,
          newPassword: _newPassController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Senha alterada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        log('FirebaseAuthException code: ${e.code}, message: ${e.message}');
        String errorMessage = 'Ocorreu um erro ao alterar a senha.';
        if (e.code == 'wrong-password' ||
            e.code == 'invalid-credential' ||
            e.code == 'INVALID_LOGIN_CREDENTIALS') {
          errorMessage =
              'A senha atual está incorreta. Verifique e tente novamente.';
        } else if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = 'Erro: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        log('Generic Exception: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ocorreu um erro inesperado. Tente novamente mais tarde.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPassController.text) return 'As senhas não coincidem';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Alterar senha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: true,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha atual',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: true,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Nova senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPassController,
                      obscureText: true,
                      validator: _validateConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirme sua nova senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A74DA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                )
                                : const Text('Alterar senha'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4A74DA)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFF4A74DA)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
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
