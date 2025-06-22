import 'package:flutter/material.dart';
import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:diainfo/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Remedy {
  final String id;
  String name;
  String type;
  String dosage;
  String frequency;
  DateTime createdAt;

  Remedy({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'dosage': dosage,
      'frequency': frequency,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Remedy.fromMap(String id, Map<String, dynamic> map) {
    return Remedy(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}

class RemedyScreen extends StatefulWidget {
  const RemedyScreen({super.key});

  @override
  State<RemedyScreen> createState() => _RemedyScreenState();
}

class _RemedyScreenState extends State<RemedyScreen> {
  final List<Remedy> _remedies = [];
  final List<Remedy> _filteredRemedies = [];
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  
  String _selectedFilter = 'Todos';
  bool _isEditing = false;
  String? _editingId;
  bool _isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRemedies);
    _loadRemedies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _typeController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _loadRemedies() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('remedies')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _remedies.clear();
        _remedies.addAll(snapshot.docs.map((doc) => 
          Remedy.fromMap(doc.id, doc.data())
        ));
        _filteredRemedies.addAll(_remedies);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar remédios: $e')),
      );
    }
  }

  void _filterRemedies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRemedies.clear();
      _filteredRemedies.addAll(_remedies.where((remedy) {
        final matchesSearch = remedy.name.toLowerCase().contains(query) ||
            remedy.type.toLowerCase().contains(query);
        final matchesFilter = _selectedFilter == 'Todos' || 
            remedy.type == _selectedFilter;
        return matchesSearch && matchesFilter;
      }));
    });
  }

  void _showRemedyForm({Remedy? remedy}) {
    if (remedy != null) {
      _nameController.text = remedy.name;
      _typeController.text = remedy.type;
      _dosageController.text = remedy.dosage;
      _frequencyController.text = remedy.frequency;
      _editingId = remedy.id;
      _isEditing = true;
    } else {
      _nameController.clear();
      _typeController.clear();
      _dosageController.clear();
      _frequencyController.clear();
      _editingId = null;
      _isEditing = false;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isEditing ? 'Editar Remédio' : 'Adicionar Remédio',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Remédio',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo (Analgésico, Antibiótico, etc.)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o tipo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: 'Dosagem (ex: 500mg)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a dosagem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _frequencyController,
                    decoration: const InputDecoration(
                      labelText: 'Frequência (ex: 8/8 horas)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a frequência';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveRemedy,
                        child: Text(_isEditing ? 'Salvar' : 'Adicionar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRemedy() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;
        if (user == null) return;

        final newRemedy = Remedy(
          id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          type: _typeController.text,
          dosage: _dosageController.text,
          frequency: _frequencyController.text,
          createdAt: DateTime.now(),
        );

        if (_isEditing) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('remedies')
              .doc(_editingId)
              .update(newRemedy.toMap());
        } else {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('remedies')
              .add(newRemedy.toMap());
        }

        await _loadRemedies();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar remédio: $e')),
        );
      }
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este remédio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteRemedy(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRemedy(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('remedies')
          .doc(id)
          .delete();

      await _loadRemedies();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir remédio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRemedyForm(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
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

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appDefaultSize),
      child: Column(
        children: [
          _buildSearchAndFilter(),
          const SizedBox(height: 20),
          Expanded(child: _buildRemedyList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Pesquisar remédios...',
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
            children: ['Todos', 'Analgesico', 'Antibiotico', 'Anti-hipertensivo']
                .map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(type),
                  selected: _selectedFilter == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? type : 'Todos';
                      _filterRemedies();
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

  Widget _buildRemedyList() {
    if (_filteredRemedies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              _searchController.text.isEmpty
                  ? 'Nenhum remédio cadastrado'
                  : 'Nenhum remédio encontrado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredRemedies.length,
      itemBuilder: (context, index) {
        final remedy = _filteredRemedies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      remedy.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showRemedyForm(remedy: remedy),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _confirmDelete(remedy.id),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tipo: ${remedy.type}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  'Dosagem: ${remedy.dosage}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  'Frequência: ${remedy.frequency}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}