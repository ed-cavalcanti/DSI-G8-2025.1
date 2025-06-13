import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final Auth _instance = Auth._internal();

  Auth._internal();

  factory Auth() {
    return _instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
    }
  }

  Future<void> changeUserName({required String userName}) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(userName);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Tentar reautenticar o usuário com a senha atual
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Se der certo, troca a senha
      await user.updatePassword(newPassword);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
