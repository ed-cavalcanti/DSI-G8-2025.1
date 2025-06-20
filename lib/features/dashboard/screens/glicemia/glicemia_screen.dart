import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/features/auth/auth.dart';
import 'package:diainfo/models/glicemia.dart';
import 'package:diainfo/services/glicemia_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GlicemiaScreen extends StatefulWidget {
  const GlicemiaScreen({super.key});

  @override
  State<GlicemiaScreen> createState() => _GlicemiaScreenState();
}

class _GlicemiaScreenState extends State<GlicemiaScreen> {
  final GlicemiaService _glicemiaService = GlicemiaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    SectionHeader(
                      title: "Histórico de glicemia",
                      navigateBack: "/dashboard",
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Últimos Registros',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<List<Glicemia>>(
                      stream: _glicemiaService.getGlicemiaStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erro ao carregar glicemias: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Row(
                            children: [Text('Nenhuma glicemia cadastrada.')],
                          );
                        }

                        List<Glicemia> glicemias = snapshot.data!;
                        // Inverter ordem para mostrar mais recentes primeiro
                        glicemias.sort((a, b) => b.date.compareTo(a.date));

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: glicemias.length,
                          itemBuilder: (context, index) {
                            Glicemia glicemia = glicemias[index];
                            Color color = Colors.green;
                            if (glicemia.value >= 100) {
                              color = Colors.red;
                            } else if (glicemia.value >= 95) {
                              color = Colors.orangeAccent;
                            }

                            return _buildGlicemiaItem(
                              glicemia: glicemia,
                              color: color,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
            Positioned(
              bottom: 16,
              left: 30,
              right: 30,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCadastroDialog();
                },
                icon: PhosphorIcon(
                  PhosphorIcons.plusCircle(PhosphorIconsStyle.bold),
                ),
                label: const Text('Cadastrar glicemia diária'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
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

  Widget _buildGlicemiaItem({
    required Glicemia glicemia,
    required Color color,
  }) {
    final String formattedDate = DateFormat('dd/MM - HH:mm').format(glicemia.date.toDate());

    return InkWell(
      onTap: () {
        _showCadastroDialog(glicemia: glicemia);
      },
      child: Container(
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
                  Text(formattedDate, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Glicemia: ${glicemia.value} mg/dL',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      CircleAvatar(radius: 6, backgroundColor: color),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                _showDeleteDialog(glicemia);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Deletar',
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Glicemia glicemia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja deletar este registro de glicemia?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () {
                if (glicemia.id != null) {
                  _glicemiaService
                      .delete(glicemia.id!)
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Glicemia deletada!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  })
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao deletar glicemia: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showCadastroDialog({Glicemia? glicemia}) {
    final isEdit = glicemia != null;
    final TextEditingController valorController = TextEditingController(
      text: isEdit ? glicemia.value.toString() : '',
    );
    DateTime? dataSelecionada = isEdit ? glicemia.date.toDate() : null;
    TimeOfDay? horaSelecionada =
    isEdit ? TimeOfDay.fromDateTime(glicemia.date.toDate()) : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEdit ? 'Editar Glicemia' : 'Registrar Glicemia'),
              content: SingleChildScrollView(
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
                          setStateDialog(() {
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
                          setStateDialog(() {
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

                      if (valor != null) {
                        final userId = Auth().currentUser?.uid;
                        if (userId == null) {
                          Navigator.pushReplacementNamed(context, '/tree');
                          return;
                        }

                        final dataHoraCombinada = DateTime(
                          dataSelecionada!.year,
                          dataSelecionada!.month,
                          dataSelecionada!.day,
                          horaSelecionada!.hour,
                          horaSelecionada!.minute,
                        );

                        final glicemiaData = Glicemia(
                          id: isEdit ? glicemia.id : null,
                          userId: userId,
                          value: valor,
                          date: Timestamp.fromDate(dataHoraCombinada),
                        );

                        final Future<void> action = isEdit
                            ? _glicemiaService.update(glicemiaData)
                            : _glicemiaService.create(glicemiaData);

                        action.then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEdit
                                  ? 'Glicemia atualizada!'
                                  : 'Glicemia registrada!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Erro ao ${isEdit ? "atualizar" : "registrar"} glicemia: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
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
      },
    );
  }
}