import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/checkup.dart';

class CheckupService {
  final CollectionReference _checkupCollection = FirebaseFirestore.instance
      .collection('checkup');

  Future<void> create(Checkup checkup) async {
    if (Auth().currentUser?.uid != checkup.userId) {
      throw Exception(
        "O objeto de checkup não pertence ao usuário autenticado.",
      );
    }
    await _checkupCollection.add(checkup.toFirestore());
  }

  Future<void> update(Checkup checkup) async {
    if (checkup.id == null) {
      throw Exception("ID do checkup não pode ser nulo para atualização.");
    }
    if (Auth().currentUser?.uid != checkup.userId) {
      throw Exception("Não autorizado a atualizar este checkup.");
    }
    await _checkupCollection.doc(checkup.id).update(checkup.toFirestore());
  }

  Future<void> delete(String id) async {
    DocumentSnapshot doc = await _checkupCollection.doc(id).get();
    if (doc.exists) {
      Checkup checkupToDelete = Checkup.fromFirestore(doc);
      if (Auth().currentUser?.uid != checkupToDelete.userId) {
        throw Exception("Não autorizado a deletar este checkup.");
      }
    } else {
      throw Exception("Checkup não encontrado.");
    }
    await _checkupCollection.doc(id).delete();
  }

  Future<Checkup?> getById(String id) async {
    DocumentSnapshot doc = await _checkupCollection.doc(id).get();
    if (doc.exists) {
      Checkup checkup = Checkup.fromFirestore(doc);
      if (Auth().currentUser?.uid != checkup.userId) {
        return null;
      }
      return checkup;
    }
    return null;
  }

  Stream<List<Checkup>> getCheckupStream() {
    final String? currentUserId = Auth().currentUser?.uid;

    if (currentUserId == null) {
      return Stream.error("Usuário não autenticado.");
    }

    return _checkupCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Checkup.fromFirestore(doc))
              .toList();
        });
  }
}
