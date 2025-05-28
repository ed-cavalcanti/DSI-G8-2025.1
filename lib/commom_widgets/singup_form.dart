import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SingupForm extends StatefulWidget {
  const SingupForm({super.key});

  @override
  State<SingupForm> createState() => _SingupFormState();
}

class _SingupFormState extends State<SingupForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _showMessage('Este e-mail já está cadastrado');
        } else {
          _showMessage('Úsuário ou senha incorretos');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return 'Insira seu nome';
    if (name.length < 3) return 'Nome deve ter ao menos e caracteres';
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Informe um email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) return 'Insira um e-mail válido';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Insira sua senha';
    if (password.length < 6) {
      return 'A senha deve ter pelo ao 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirme sua senha';
    }
    if (confirmPassword != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: appFormHeight - 10),
      margin: EdgeInsets.only(top: 20.0),
      child: Form(
        key: _formKey,
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
              controller: _nameController,
              validator: _validateName,
            ),
            const SizedBox(height: appFormHeight - 10),
            TextFormField(
              decoration: InputDecoration(
                label: Text("E-mail"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.envelopeSimple(PhosphorIconsStyle.bold),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              controller: _emailController,
            ),
            const SizedBox(height: appFormHeight - 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                label: Text("Senha"),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.fingerprintSimple(PhosphorIconsStyle.bold),
                ),
              ),
              obscureText: true,
              validator: _validatePassword,
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
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: 160.0),
            SizedBox(
              width: double.infinity,
              height: appButtonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : signUpWithEmailAndPassword,
                child:
                    _isLoading
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                        : Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
