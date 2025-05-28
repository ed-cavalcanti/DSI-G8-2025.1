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

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
