import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diainfo/models/remedy.dart';

class RemedyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referência à coleção de remédios do usuário
  CollectionReference get _userRemedies {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuário não autenticado');
    return _firestore.collection('users').doc(userId).collection('remedies');
  }

  // Adiciona um novo remédio
  Future<void> addRemedy(Remedy remedy) async {
    await _userRemedies.add(remedy.toMap());
  }

  // Atualiza um remédio existente
  Future<void> updateRemedy(Remedy remedy) async {
    if (remedy.id.isEmpty) throw Exception('ID do remédio não pode ser vazio');
    await _userRemedies.doc(remedy.id).update(remedy.toMap());
  }

  // Remove um remédio
  Future<void> deleteRemedy(String id) async {
    await _userRemedies.doc(id).delete();
  }

  // Stream de todos os remédios em tempo real
  Stream<List<Remedy>> get remediesStream {
    return _userRemedies
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Remedy.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}