import 'package:diainfo/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final String? photoUrl;

  const UserAvatar({super.key, this.user, this.radius = 25, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/profile');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: _getImageProvider(),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    final String? imageUrl = photoUrl ?? user?.photoURL;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Adiciona um parâmetro único na URL para evitar cache
      final String uniqueUrl =
          imageUrl.contains('?')
              ? '$imageUrl&t=${DateTime.now().millisecondsSinceEpoch}'
              : '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      return NetworkImage(uniqueUrl);
    }

    return const AssetImage('assets/avatar.png');
  }
}

class CurrentUserAvatar extends StatefulWidget {
  final double radius;

  const CurrentUserAvatar({super.key, this.radius = 25});

  @override
  State<CurrentUserAvatar> createState() => _CurrentUserAvatarState();
}

class _CurrentUserAvatarState extends State<CurrentUserAvatar> {
  String? _lastPhotoUrl;
  Key _imageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final user = Auth().currentUser;

    // Verifica se a URL da foto mudou para forçar reconstrução
    if (_lastPhotoUrl != user?.photoURL) {
      _lastPhotoUrl = user?.photoURL;
      _imageKey = UniqueKey(); // Força reconstrução da imagem
    }

    return UserAvatar(user: user, radius: widget.radius, key: _imageKey);
  }
}
