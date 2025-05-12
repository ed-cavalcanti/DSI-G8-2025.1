import 'package:diainfo/commom_widgets/column_chart.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Topo com logo e saudação
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
                  Row(
                    children: const [
                      Text('Olá, ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Marco',
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
                ],
              ),

              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              // Gráfico mockado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF3F6FA),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Janeiro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ColumnChart(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('cadastrar glicemia diária'),
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
                        // ação para ver mais check-ups
                      },
                      child: const Text(
                        'ver mais >',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _buildCheckupItem('10/01/2025', 'Moderado', Colors.yellow),
              _buildCheckupItem('03/01/2025', 'Alto', Colors.red),
              _buildCheckupItem('01/10/2024', 'Baixo', Colors.green),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
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
}
