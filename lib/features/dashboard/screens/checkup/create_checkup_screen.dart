import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/checkup_form.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/checkup.dart';
import 'package:diainfo/services/checkup_service.dart';
import 'package:flutter/material.dart';

class CreateCheckupScreen extends StatefulWidget {
  const CreateCheckupScreen({super.key});

  @override
  State<CreateCheckupScreen> createState() => _CreateCheckupScreenState();
}

class _CreateCheckupScreenState extends State<CreateCheckupScreen> {
  final CheckupService _checkupService = CheckupService();
  final GlobalKey<CheckupFormState> _formKey = GlobalKey<CheckupFormState>();
  bool _isLoading = false;

  Future<void> _saveCheckup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.getFormData();
        final currentUser = Auth().currentUser;

        if (currentUser == null) {
          _showMessage('Usuário não autenticado', isError: true);
          return;
        }
        final checkup = Checkup(
          userId: currentUser.uid,
          name: formData['name'],
          age: formData['age'],
          gender: formData['gender'],
          physicalActivity: formData['physicalActivity'],
          smoker: formData['smoker'],
          alcohol: formData['alcohol'],
          highBp: formData['highBp'],
          highChol: formData['highChol'],
          risk: formData['risk'],
          date: Timestamp.now(),
        );

        await _checkupService.create(checkup);

        _showMessage('Checkup salvo com sucesso!', isError: false);

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } catch (e) {
        _showMessage('Erro ao salvar checkup: $e', isError: true);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Navbar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: appDefaultSize,
                  vertical: appDefaultSize,
                ),
                child: Column(
                  children: [
                    SectionHeader(
                      title: "Novo check-up",
                      navigateBack: "/checkup",
                    ),
                    const SizedBox(height: 20),
                    CheckupForm(key: _formKey),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveCheckup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Salvar Check-up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
