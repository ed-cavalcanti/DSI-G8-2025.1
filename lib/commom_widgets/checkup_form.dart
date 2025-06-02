import 'package:diainfo/models/checkup.dart';
import 'package:flutter/material.dart';

import 'custom_radio_selector.dart';

class CheckupForm extends StatefulWidget {
  final Checkup? initialCheckup;

  const CheckupForm({super.key, this.initialCheckup});

  @override
  CheckupFormState createState() => CheckupFormState();
}

class CheckupFormState extends State<CheckupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  UserGender _selectedGender = UserGender.male;
  BinaryQuestion _physicalActivity = BinaryQuestion.yes;
  BinaryQuestion _smoker = BinaryQuestion.no;
  BinaryQuestion _alcohol = BinaryQuestion.no;
  BinaryQuestion _highBp = BinaryQuestion.no;
  BinaryQuestion _highChol = BinaryQuestion.no;
  String? _selectedRisk;
  final List<String> _risk = ['Baixo', 'Moderado', 'Alto'];

  @override
  void initState() {
    super.initState();
    _initializeFormWithCheckup();
  }

  void _initializeFormWithCheckup() {
    if (widget.initialCheckup != null) {
      final checkup = widget.initialCheckup!; // Inicializar campos de texto
      _nameController.text = checkup.name;
      _ageController.text = checkup.age.toString();

      // Inicializar valores dos enums
      _selectedGender = checkup.gender;
      _physicalActivity = checkup.physicalActivity;
      _smoker = checkup.smoker;
      _alcohol = checkup.alcohol;
      _highBp = checkup.highBp;
      _highChol = checkup.highChol;

      // Inicializar risco
      switch (checkup.risk) {
        case Risk.low:
          _selectedRisk = 'Baixo';
          break;
        case Risk.moderate:
          _selectedRisk = 'Moderado';
          break;
        case Risk.high:
          _selectedRisk = 'Alto';
          break;
      }
    }
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return 'Insira seu nome';
    if (name.length < 3) return 'Nome deve ter ao menos e caracteres';
    return null;
  }

  String? _validateAge(String? age) {
    if (age == null || age.isEmpty) return 'Insira sua idade';
    final intAge = int.tryParse(age);
    if (intAge == null) return 'Idade inválida';
    if (intAge < 18) return 'Idade deve ser maior que 18';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Text("Informações básicas", style: TextStyle(fontSize: 16.0)),
              ],
            ),
            SizedBox(height: 8.0),
            TextFormField(
              decoration: InputDecoration(label: Text("Nome")),
              controller: _nameController,
              validator: _validateName,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(label: Text("Idade")),
              controller: _ageController,
              validator: _validateAge,
              keyboardType: TextInputType.numberWithOptions(),
            ),
            SizedBox(height: 20.0),
            Row(children: [Text("Gênero", style: TextStyle(fontSize: 16.0))]),
            SizedBox(height: 8.0),
            CustomRadioSelector(
              selectedValue: _selectedGender,
              options: UserGender.values,
              labels: {UserGender.male: "Homem", UserGender.female: "Mulher"},
              onValueChanged: (gender) {
                setState(() {
                  _selectedGender = gender;
                });
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  "Pratica atividades físicas?",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Text(
              "Considere atividades físicas de intensidade moderada, ao menos 3 vezes por semana.",
              style: TextStyle(fontSize: 13.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 12.0),
            CustomRadioSelector(
              selectedValue: _physicalActivity,
              options: BinaryQuestion.values,
              labels: {BinaryQuestion.yes: "Sim", BinaryQuestion.no: "Não"},
              onValueChanged: (value) {
                setState(() {
                  _physicalActivity = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: [Text("É fumante?", style: TextStyle(fontSize: 16.0))],
            ),
            Text(
              "Considere sim se já consumiu mais de 100 cigarros (5 maços) durante a vida.",
              style: TextStyle(fontSize: 13.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 12.0),
            CustomRadioSelector(
              selectedValue: _smoker,
              options: BinaryQuestion.values,
              labels: {BinaryQuestion.yes: "Sim", BinaryQuestion.no: "Não"},
              onValueChanged: (value) {
                setState(() {
                  _smoker = value;
                });
              },
            ),

            SizedBox(height: 20.0),
            Row(
              children: [
                Text("Consome álcool?", style: TextStyle(fontSize: 16.0)),
              ],
            ),
            Text(
              "Considere sim se consome 3 drinks ou mais durante a semana.",
              style: TextStyle(fontSize: 13.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 12.0),
            CustomRadioSelector(
              selectedValue: _alcohol,
              options: BinaryQuestion.values,
              labels: {BinaryQuestion.yes: "Sim", BinaryQuestion.no: "Não"},
              onValueChanged: (value) {
                setState(() {
                  _alcohol = value;
                });
              },
            ),

            SizedBox(height: 20.0),
            Row(
              children: [
                Text("Possui pressão alta?", style: TextStyle(fontSize: 16.0)),
              ],
            ),
            SizedBox(height: 12.0),
            CustomRadioSelector(
              selectedValue: _highBp,
              options: BinaryQuestion.values,
              labels: {BinaryQuestion.yes: "Sim", BinaryQuestion.no: "Não"},
              onValueChanged: (value) {
                setState(() {
                  _highBp = value;
                });
              },
            ),

            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  "Possui colesterol alto?",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            CustomRadioSelector(
              selectedValue: _highChol,
              options: BinaryQuestion.values,
              labels: {BinaryQuestion.yes: "Sim", BinaryQuestion.no: "Não"},
              onValueChanged: (value) {
                setState(() {
                  _highChol = value;
                });
              },
            ),
            SizedBox(height: 20.0),

            Row(
              children: [
                Text(
                  "Qual seu nível de risco de contrair diabetes?",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Text(
              "Pergunte a um profissional de saúde de sua confiança.",
              style: TextStyle(fontSize: 13.0, color: Colors.grey[600]),
            ),

            SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              value: _selectedRisk,
              style: TextStyle(color: Colors.black87, fontSize: 16),
              dropdownColor: Color.fromARGB(255, 243, 246, 252),
              hint: Text('Selecione uma opção'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Color(0xFF4A74DA)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione o nível de risco';
                }
                return null;
              },
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRisk = newValue;
                });
              },
              items:
                  _risk.map<DropdownMenuItem<String>>((String risk) {
                    return DropdownMenuItem<String>(
                      value: risk,
                      child: Text(risk),
                    );
                  }).toList(),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getFormData() {
    // Converte o risco selecionado de string para enum
    Risk selectedRisk = Risk.low;
    if (_selectedRisk == 'Moderado') {
      selectedRisk = Risk.moderate;
    } else if (_selectedRisk == 'Alto') {
      selectedRisk = Risk.high;
    }

    return {
      'name': _nameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'gender': _selectedGender,
      'physicalActivity': _physicalActivity,
      'smoker': _smoker,
      'alcohol': _alcohol,
      'highBp': _highBp,
      'highChol': _highChol,
      'risk': selectedRisk,
    };
  }
}
