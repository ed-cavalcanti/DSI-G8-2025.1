import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/glicemia.dart';

class GlicemiaService {
  final CollectionReference _glicemiaCollection = FirebaseFirestore.instance
      .collection('glicemia');

  Future<void> create(Glicemia glicemia) async {
    if (Auth().currentUser?.uid != glicemia.userId) {
      throw Exception(
        "O objeto de glicemia não pertence ao usuário autenticado.",
      );
    }
    await _glicemiaCollection.add(glicemia.toFirestore());
  }

  Future<void> update(Glicemia glicemia) async {
    if (glicemia.id == null) {
      throw Exception("ID da glicemia não pode ser nulo para atualização.");
    }
    if (Auth().currentUser?.uid != glicemia.userId) {
      throw Exception("Não autorizado a atualizar esta glicemia.");
    }
    await _glicemiaCollection.doc(glicemia.id).update(glicemia.toFirestore());
  }

  Future<void> delete(String id) async {
    DocumentSnapshot doc = await _glicemiaCollection.doc(id).get();
    if (doc.exists) {
      Glicemia glicemiaToDelete = Glicemia.fromFirestore(doc);
      if (Auth().currentUser?.uid != glicemiaToDelete.userId) {
        throw Exception("Não autorizado a deletar esta glicemia.");
      }
    } else {
      throw Exception("Glicemia não encontrado.");
    }
    await _glicemiaCollection.doc(id).delete();
  }

  Future<Glicemia?> getById(String id) async {
    DocumentSnapshot doc = await _glicemiaCollection.doc(id).get();
    if (doc.exists) {
      Glicemia glicemia = Glicemia.fromFirestore(doc);
      if (Auth().currentUser?.uid != glicemia.userId) {
        return null;
      }
      return glicemia;
    }
    return null;
  }

  Stream<List<Glicemia>> getGlicemiaStream() {
    final String? currentUserId = Auth().currentUser?.uid;

    if (currentUserId == null) {
      return Stream.error("Usuário não autenticado.");
    }

    return _glicemiaCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Glicemia.fromFirestore(doc))
              .toList();
        });
  }
}
