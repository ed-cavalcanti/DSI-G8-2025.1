import 'dart:io';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/services/image_upload_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Auth _auth = Auth();
  final ImageUploadService _imageUploadService = ImageUploadService();
  User? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSaving = false;
  bool _isUploadingImage = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _nameController.text = _user!.displayName ?? '';
      _emailController.text = _user!.email ?? '';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Digite sua senha para confirmar a exclusão da conta. Esta ação não pode ser desfeita.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAccount(passwordController.text.trim());
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (email == null) {
        throw FirebaseAuthException(
          code: 'no-email',
          message: 'Usuário sem e-mail associado.',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user!.reauthenticateWithCredential(credential);
      await user.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta deletada com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro: ${e.message}';
      if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro desconhecido: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _updateUserName() async {
    if (_user != null && _nameController.text.isNotEmpty) {
      setState(() {
        _isSaving = true;
      });
      try {
        await _auth.changeUserName(userName: _nameController.text);
        setState(() {
          _user = _auth.currentUser;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nome atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar o nome: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar foto'),
        content: const Text('Escolha a origem da sua foto de perfil:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickAndUploadImage(ImageSource.camera);
            },
            child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickAndUploadImage(ImageSource.gallery);
            },
            child: const Text('Galeria'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    if (_user == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final File? imageFile = await _imageUploadService.pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });

        final String imageUrl = await _imageUploadService.uploadImage(
          imageFile,
          _user!.uid,
        );

        await _auth.updateProfilePhoto(photoUrl: imageUrl);

        setState(() {
          _user = _auth.currentUser;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar foto: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : _user?.photoURL != null
                          ? NetworkImage(_user!.photoURL!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                      child: _isUploadingImage
                          ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A74DA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _user?.displayName ?? 'Nome Completo',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(label: 'Nome', controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'E-mail',
                controller: _emailController,
                enabled: false,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _updateUserName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A74DA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Salvar alterações'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/changepass');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF4A74DA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Alterar senha',
                    style: TextStyle(color: Color(0xFF4A74DA)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await Auth().signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  Text(
                    "Zona de perigo",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Deletar minha conta',
                    style: TextStyle(color: Colors.red),
                  ),
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
            '/remedy',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF4A74DA)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
