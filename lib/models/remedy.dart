

class Remedy {
  final String id;
  final String name;
  final String type;
  final String dosage;
  final String frequency;
  final DateTime createdAt;

  Remedy({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.createdAt,
  });

  // Converte para Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'dosage': dosage,
      'frequency': frequency,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Cria a partir de Map (Firestore)
  factory Remedy.fromMap(String id, Map<String, dynamic> map) {
    return Remedy(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }
}