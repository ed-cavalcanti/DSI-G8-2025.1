import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/commom_widgets/section_header.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  List<Checkup> _allCheckups = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCheckups);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCheckups() {
    setState(() {});
  }

  String _getRiskText(Risk risk) {
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
                    const SectionHeader(
                      title: "Histórico de check-ups",
                      navigateBack: "/dashboard",
                    ),
                    const SizedBox(height: 30),
                    _buildFilterSection(),
                    const SizedBox(height: 20),
                    StreamBuilder<List<Checkup>>(
                      stream: _checkupService.getCheckupStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erro ao carregar checkups: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Nenhum checkup cadastrado.'),
                          );
                        }

                        _allCheckups = snapshot.data!;
                        List<Checkup> filteredCheckups = _applyFilters(_allCheckups);

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: filteredCheckups.length,
                          itemBuilder: (context, index) {
                            Checkup checkup = filteredCheckups[index];
                            Color color = _getRiskColor(checkup.risk);
                            String riskText = _getRiskText(checkup.risk);

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
            const Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
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
                label: const Text("Cadastrar novo check-up"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize: const Size(double.infinity, 48),
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
            '/remedy',
          ];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar check-ups...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todos', 'Baixo', 'Moderado', 'Alto'].map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? filter : 'Todos';
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<Checkup> _applyFilters(List<Checkup> checkups) {
    final query = _searchController.text.toLowerCase();
    return checkups.where((checkup) {
      final formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(checkup.date.toDate());
      final matchesSearch = formattedDate.toLowerCase().contains(query) ||
          _getRiskText(checkup.risk).toLowerCase().contains(query);
      final matchesFilter = _selectedFilter == 'Todos' ||
          _getRiskText(checkup.risk) == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildCheckupItem({
    required Checkup checkup,
    required Color color,
    required String riskText,
  }) {
    final String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(checkup.date.toDate());
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
                      Text('Risco: $riskText', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      CircleAvatar(radius: 6, backgroundColor: color),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                _showDeleteDialog(checkup);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Deletar',
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
                  _checkupService.delete(checkup.id!).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checkup deletado!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
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
