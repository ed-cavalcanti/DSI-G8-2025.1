import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/checkup_form.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/checkup.dart';
import 'package:diainfo/services/checkup_service.dart';
import 'package:flutter/material.dart';

class UpdateCheckupScreen extends StatefulWidget {
  final Checkup checkup;

  const UpdateCheckupScreen({super.key, required this.checkup});

  @override
  State<UpdateCheckupScreen> createState() => _UpdateCheckupScreenState();
}

class _UpdateCheckupScreenState extends State<UpdateCheckupScreen> {
  final CheckupService _checkupService = CheckupService();
  final GlobalKey<CheckupFormState> _formKey = GlobalKey<CheckupFormState>();
  bool _isLoading = false;

  Future<void> _updateCheckup() async {
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

        if (widget.checkup.userId != currentUser.uid) {
          _showMessage(
            'Não autorizado a atualizar este checkup',
            isError: true,
          );
          return;
        }

        final updatedCheckup = widget.checkup.copyWith(
          name: formData['name'],
          age: formData['age'],
          gender: formData['gender'],
          physicalActivity: formData['physicalActivity'],
          smoker: formData['smoker'],
          alcohol: formData['alcohol'],
          highBp: formData['highBp'],
          highChol: formData['highChol'],
          risk: formData['risk'],
        );

        await _checkupService.update(updatedCheckup);

        _showMessage('Checkup atualizado com sucesso!', isError: false);

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } catch (e) {
        _showMessage('Erro ao atualizar checkup: $e', isError: true);
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
                      title: "Editar check-up",
                      navigateBack: "/checkup",
                    ),
                    const SizedBox(height: 20),
                    CheckupForm(key: _formKey, initialCheckup: widget.checkup),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateCheckup,
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
                          'Salvar Alterações',
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
