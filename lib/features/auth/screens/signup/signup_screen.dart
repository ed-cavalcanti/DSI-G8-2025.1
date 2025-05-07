import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/commom_widgets/singup_form.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            // Imagem de fundo
            Positioned.fill(
              child: Image.asset(
                'assets/signup-background.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: appDefaultSize,
                  vertical: 60.0,
                ),
                child: Column(
                  children: [
                    SectionHeader(title: 'Cadastro', navigateBack: '/login'),
                    SingupForm(),
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
