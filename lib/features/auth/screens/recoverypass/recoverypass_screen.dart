import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:flutter/material.dart';

class RecoverypassScreen extends StatelessWidget {
  const RecoverypassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionHeader(
                      title: "Recuperar senha",
                      navigateBack: "/login",
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Digite seu e-mail para recuperação de senha:',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.left,
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
                    const SizedBox(height: 460),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A74DA),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Confirmar'),
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
