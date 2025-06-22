import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/column_chart.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/constants/colors.dart';
import 'package:diainfo/models/checkup.dart';
import 'package:diainfo/models/glicemia.dart';
import 'package:diainfo/services/checkup_service.dart';
import 'package:diainfo/services/glicemia_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlicemiaService _glicemiaService = GlicemiaService();
  final CheckupService _checkupService = CheckupService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 120), // Espaço para o AppHeader
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Histórico de glicemia',
                      style: TextStyle(fontSize: 18, color: textPrimaryColor),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF3F6FA),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Como está sua glicemia?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<List<Glicemia>>(
                          stream: _glicemiaService.getGlicemiaStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar dados: ${snapshot.error}',
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('Nenhuma glicemia cadastrada.'),
                              );
                            }

                            List<Glicemia> glicemias = snapshot.data!;

                            final chartData =
                                glicemias.map((g) {
                                  final day = DateFormat(
                                    'd',
                                  ).format(g.date.toDate());
                                  return ChartData(day, g.value.toDouble());
                                }).toList();

                            return ColumnChart(chartData: chartData);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/glicemia');
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

                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Últimos Check-Ups',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkup');
                          },
                          child: const Text(
                            'Ver mais >',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<List<Checkup>>(
                    stream: _checkupService.getCheckupStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhum check-up encontrado.'),
                        );
                      }

                      List<Checkup> checkups = snapshot.data!;

                      return Column(
                        children:
                            checkups.reversed
                                .map(
                                  (checkup) => _buildCheckupItem(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(checkup.date.toDate()),
                                    _riskToString(checkup.risk),
                                    _getRiskColor(checkup.risk),
                                  ),
                                )
                                .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          final routes = [
            '/dashboard',
            '/map',
            '/glicemia',
            '/checkup',
            '/remedy',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  Widget _buildCheckupItem(String date, String risk, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF3F6FA),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontSize: 14)),
          Row(
            children: [
              Text('Risco: $risk', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              CircleAvatar(radius: 6, backgroundColor: color),
            ],
          ),
        ],
      ),
    );
  }

  String _riskToString(Risk risk) {
    switch (risk) {
      case Risk.low:
        return 'Baixo';
      case Risk.moderate:
        return 'Moderado';
      case Risk.high:
        return 'Alto';
    }
  }

  Color _getRiskColor(Risk risk) {
    switch (risk) {
      case Risk.low:
        return Colors.green;
      case Risk.moderate:
        return Colors.orangeAccent;
      case Risk.high:
        return Colors.red;
    }
  }
}
