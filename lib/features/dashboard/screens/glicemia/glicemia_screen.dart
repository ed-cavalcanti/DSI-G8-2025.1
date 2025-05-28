import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlicemiaScreen extends StatefulWidget {
  const GlicemiaScreen({super.key});

  @override
  State<GlicemiaScreen> createState() => _GlicemiaScreenState();
}

class _GlicemiaScreenState extends State<GlicemiaScreen> {
  final List<Map<String, dynamic>> registros = [
    {
      'data': '10/01/2025',
      'hora': '08:00',
      'valor': '120 mg/dL',
      'cor': Colors.green,
    },
    {
      'data': '09/01/2025',
      'hora': '12:00',
      'valor': '180 mg/dL',
      'cor': Colors.yellow,
    },
    {
      'data': '08/01/2025',
      'hora': '18:00',
      'valor': '220 mg/dL',
      'cor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Diainfo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A74DA),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Row(
                            children: const [
                              Text('Olá, ', style: TextStyle(fontSize: 16)),
                              Text(
                                'usuário',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 6),
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage('avatar.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Histórico de glicemia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Acompanhe seus registros de glicemia passados',
                        style: TextStyle(fontSize: 18, color: textPrimaryColor),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Últimos Registros',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'ver mais >',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    for (var i = 0; i < registros.length; i++)
                      _buildGlicemiaItem(
                        index: i,
                        dateTime:
                            '${registros[i]['data']} ${registros[i]['hora']}',
                        value: registros[i]['valor'],
                        color: registros[i]['cor'],
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showCadastroDialog();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Cadastrar glicemia diária'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A74DA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          final routes = [
            '/dashboard',
            '/map',
            '/glicemia',
            '/checkup',
            '/profile',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  void _showCadastroDialog({int? indexEditar}) {
    final isEdit = indexEditar != null;
    final TextEditingController valorController = TextEditingController(
      text:
          isEdit
              ? registros[indexEditar]['valor'].toString().split(' ').first
              : '',
    );
    DateTime? dataSelecionada =
        isEdit
            ? DateFormat('dd/MM/yyyy').parse(registros[indexEditar]['data'])
            : null;
    TimeOfDay? horaSelecionada =
        isEdit ? _parseHora(registros[indexEditar]['hora']) : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Editar Glicemia' : 'Registrar Glicemia'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        dataSelecionada != null
                            ? DateFormat('dd/MM/yyyy').format(dataSelecionada!)
                            : 'Selecionar data',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dataSelecionada ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            dataSelecionada = picked;
                          });
                        }
                      },
                    ),

                    ListTile(
                      title: Text(
                        horaSelecionada != null
                            ? horaSelecionada!.format(context)
                            : 'Selecionar hora',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: horaSelecionada ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            horaSelecionada = picked;
                          });
                        }
                      },
                    ),

                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor da Glicemia (mg/dL)',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (dataSelecionada != null &&
                    horaSelecionada != null &&
                    valorController.text.isNotEmpty) {
                  final valor = int.tryParse(valorController.text);

                  Color cor;
                  if (valor != null) {
                    if (valor < 140) {
                      cor = Colors.green;
                    } else if (valor < 200) {
                      cor = Colors.yellow;
                    } else {
                      cor = Colors.red;
                    }

                    final novoRegistro = {
                      'data': DateFormat('dd/MM/yyyy').format(dataSelecionada!),
                      'hora': horaSelecionada!.format(context),
                      'valor': '${valorController.text} mg/dL',
                      'cor': cor,
                    };

                    setState(() {
                      if (isEdit) {
                        registros[indexEditar] = novoRegistro;
                      } else {
                        registros.insert(0, novoRegistro);
                      }
                    });

                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlicemiaItem({
    required int index,
    required String dateTime,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF3F6FA),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateTime, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Glicemia: $value',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(radius: 6, backgroundColor: color),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _showCadastroDialog(indexEditar: index);
                },
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Editar',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    registros.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Deletar',
              ),
            ],
          ),
        ],
      ),
    );
  }

  TimeOfDay _parseHora(String hora) {
    final parts = hora.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
