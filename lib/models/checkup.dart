import 'package:cloud_firestore/cloud_firestore.dart';

enum UserGender { male, female }

enum BinaryQuestion { yes, no }

enum Risk { low, moderate, high }

class Checkup {
  String? id;
  String userId;
  String name;
  int age;
  UserGender gender;
  BinaryQuestion physicalActivity;
  BinaryQuestion smoker;
  BinaryQuestion alcohol;
  BinaryQuestion highBp;
  BinaryQuestion highChol;
  Risk risk;
  Timestamp date;

  Checkup({
    this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.physicalActivity,
    required this.smoker,
    required this.alcohol,
    required this.highBp,
    required this.highChol,
    required this.risk,
    required this.date,
  });

  // Transforma um Documento (forma armazenada no firebase) em um objeto do tipo Checkup
  factory Checkup.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Checkup(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      gender: UserGender.values.firstWhere(
        (e) => e.name == data['gender'],
        orElse: () => UserGender.male,
      ),
      physicalActivity: BinaryQuestion.values.firstWhere(
        (e) => e.name == data['physicalActivity'],
        orElse: () => BinaryQuestion.no,
      ),
      smoker: BinaryQuestion.values.firstWhere(
        (e) => e.name == data['smoker'],
        orElse: () => BinaryQuestion.no,
      ),
      alcohol: BinaryQuestion.values.firstWhere(
        (e) => e.name == data['alcohol'],
        orElse: () => BinaryQuestion.no,
      ),
      highBp: BinaryQuestion.values.firstWhere(
        (e) => e.name == data['highBp'],
        orElse: () => BinaryQuestion.no,
      ),
      highChol: BinaryQuestion.values.firstWhere(
        (e) => e.name == data['highChol'],
        orElse: () => BinaryQuestion.no,
      ),
      risk: Risk.values.firstWhere(
        (e) => e.name == data['risk'],
        orElse: () => Risk.low,
      ),
      date:
          data['date'] is Timestamp
              ? data['date'] as Timestamp
              : Timestamp.now(),
    );
  }

  // Transforma um objeto do tipo Checkup para Map<String, dynamic>, para salvar no firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender.name,
      'physicalActivity': physicalActivity.name,
      'smoker': smoker.name,
      'alcohol': alcohol.name,
      'highBp': highBp.name,
      'highChol': highChol.name,
      'risk': risk.name,
      'date': date,
    };
  }

  // Método para copiar um objeto Checkup com novos valores, útil se o objeto precisar ser atualizado
  Checkup copyWith({
    String? id,
    String? userId,
    String? name,
    int? age,
    UserGender? gender,
    BinaryQuestion? physicalActivity,
    BinaryQuestion? smoker,
    BinaryQuestion? alcohol,
    BinaryQuestion? highBp,
    BinaryQuestion? highChol,
    Risk? risk,
    Timestamp? date,
  }) {
    return Checkup(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      physicalActivity: physicalActivity ?? this.physicalActivity,
      smoker: smoker ?? this.smoker,
      alcohol: alcohol ?? this.alcohol,
      highBp: highBp ?? this.highBp,
      highChol: highChol ?? this.highChol,
      risk: risk ?? this.risk,
      date: date ?? this.date,
    );
  }
}
