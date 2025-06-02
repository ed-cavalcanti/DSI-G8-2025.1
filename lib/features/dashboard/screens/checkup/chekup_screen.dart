import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/commom_widgets/section_header.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:diainfo/features/dashboard/screens/checkup/update_checkup_screen.dart';
import 'package:diainfo/models/checkup.dart';
import 'package:diainfo/services/checkup_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CheckupScreen extends StatefulWidget {
  const CheckupScreen({super.key});

  @override
  State<CheckupScreen> createState() => _CheckupScreenState();
}

class _CheckupScreenState extends State<CheckupScreen> {
  final CheckupService _checkupService = CheckupService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: appDefaultSize,
                  vertical: appDefaultSize,
                ),
                child: Column(
                  children: [
                    AppHeader(),
                    const SizedBox(height: 30),
                    SectionHeader(
                      title: "Histórico de check-ups",
                      navigateBack: "/dashboard",
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Últimos Registros',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    StreamBuilder<List<Checkup>>(
                      stream: _checkupService.getCheckupStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar checkups: ${snapshot.error}',
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Row(
                            children: [Text('Nenhum checkup cadastrado.')],
                          );
                        }

                        List<Checkup> checkups = snapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: checkups.length,
                          itemBuilder: (context, index) {
                            Checkup checkup = checkups[index];
                            Color color = Colors.green;
                            String riskText = 'Baixo';

                            if (checkup.risk == Risk.high) {
                              color = Colors.red;
                              riskText = 'Alto';
                            } else if (checkup.risk == Risk.moderate) {
                              color = Colors.orangeAccent;
                              riskText = 'Moderado';
                            }

                            return _buildCheckupItem(
                              checkup: checkup,
                              color: color,
                              riskText: riskText,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 30.0,
              right: 30.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkup/create');
                },
                icon: PhosphorIcon(
                  PhosphorIcons.plusCircle(PhosphorIconsStyle.bold),
                ),
                label: Text("Cadastrar novo check-up"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize: Size(
                    double.infinity,
                    48,
                  ), // Botão com largura total
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
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

  Widget _buildCheckupItem({
    required Checkup checkup,
    required Color color,
    required String riskText,
  }) {
    final String formattedDate = DateFormat(
      'dd/MM/yyyy - HH:mm',
    ).format(checkup.date.toDate());
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateCheckupScreen(checkup: checkup),
          ),
        );
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
                      Text(
                        'Risco: $riskText',
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
                    _showDeleteDialog(checkup);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Deletar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Checkup checkup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja deletar este checkup?'),
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
                if (checkup.id != null) {
                  _checkupService
                      .delete(checkup.id!)
                      .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkup deletado!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context).pop();
                      })
                      .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao deletar checkup: $error'),
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
}
