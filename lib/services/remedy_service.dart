import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/remedy.dart';

class RemedyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = Auth();

  CollectionReference get _remediesCollection =>
      _firestore.collection('remedies');

  Future<void> addRemedy(Remedy remedy) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuário não autenticado');

    final remedyData = remedy.toMap();
    remedyData['userId'] = userId;

    await _remediesCollection.add(remedyData);
  }

  Future<void> updateRemedy(Remedy remedy) async {
    if (remedy.id.isEmpty) throw Exception('ID do remédio não pode ser vazio');
    await _remediesCollection.doc(remedy.id).update(remedy.toMap());
  }

  Future<void> deleteRemedy(String id) async {
    await _remediesCollection.doc(id).delete();
  }

  Stream<List<Remedy>> get remediesStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _remediesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Remedy.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
        );
  }
}
