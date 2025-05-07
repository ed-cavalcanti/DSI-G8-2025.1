import 'package:diainfo/constants/sizes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    SizedBox(height: 120.0),
                    Text("Conteúdo da página"),
                    SizedBox(height: 120.0),
                    SizedBox(
                      width: double.infinity,
                      height: appButtonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text("Cadastrar"),
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
