import 'package:cloud_firestore/cloud_firestore.dart';

class Glicemia {
  String? id; // É opcional pois é gerado automaticamente pelo firestore
  String userId;
  Timestamp date;
  int value;

  Glicemia({
    this.id,
    required this.userId,
    required this.date,
    required this.value,
  });

  // Transforma um Documento (forma armazenada no firebase) em um objeto do tipo Glicemia
  factory Glicemia.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Glicemia(
      id: doc.id,
      userId: data['userId'] ?? '',
      date:
          data['date'] is Timestamp
              ? data['date'] as Timestamp
              : Timestamp.now(),
      value: (data['value'] as num?)?.toInt() ?? 0,
    );
  }

  // Transforma um objeto do tipo Glicemia para Map<String, dynamic>, para salvar no firestore
  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'value': value,
      'userId': userId
    };
  }

  // Método para copiar um objeto Glicemia com novos valores, útil se o objeto precisar ser atualizado
  Glicemia copyWith({String? id, String? userId, Timestamp? date, int? value}) {
    return Glicemia(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }
}
