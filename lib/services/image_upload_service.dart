import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  // Substitua pelos seus dados do Cloudinary
  // Para obter, crie uma conta gratuita em: https://cloudinary.com/
  static const String _cloudName = 'SEU_CLOUD_NAME_AQUI';
  static const String _uploadPreset = 'SEU_UPLOAD_PRESET_AQUI';

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao selecionar imagem: $e');
    }
  }

  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String publicId = 'profile_images/user_${userId}_$timestamp';

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          publicId: publicId,
          folder: 'profile_images',
        ),
      );

      String imageUrl = response.secureUrl;
      if (!imageUrl.contains('?')) {
        imageUrl += '?v=$timestamp';
      } else {
        imageUrl += '&v=$timestamp';
      }

      return imageUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  Future<File?> showImageSourceDialog() async {
    // Esta função será chamada pelo widget para mostrar o dialog de seleção
    return null;
  }
}
