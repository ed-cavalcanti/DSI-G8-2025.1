import 'dart:convert';

import 'package:diainfo/commom_widgets/app_header.dart';
import 'package:diainfo/commom_widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  LatLng? _currentPosition;
  List<Map<String, dynamic>> _healthUnits = [];
  bool _loading = true;
  double _searchRadius = 10.0;
  final double _initialZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _loading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    setState(
      () => _currentPosition = LatLng(position.latitude, position.longitude),
    );
    _mapController.move(_currentPosition!, _initialZoom);
    await _fetchNearbyHealthUnits(position.latitude, position.longitude);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _fetchNearbyHealthUnits(double lat, double lng) async {
    final accessToken = 'MAPBOX_TOKEN';
    final radiusInDegrees = _searchRadius / 111.0;

    final List<String> categories = ['hospital', 'clinic'];
    List<Map<String, dynamic>> allResults = [];

    for (final category in categories) {
      final response = await http.get(
        Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$category.json?'
          'proximity=$lng,$lat&type=poi&limit=30'
          '&bbox=${lng - radiusInDegrees},${lat - radiusInDegrees},${lng + radiusInDegrees},${lat + radiusInDegrees}'
          '&access_token=$accessToken',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        allResults.addAll(
          (data['features'] as List).map((feature) {
            final coords = feature['geometry']['coordinates'];
            return {
              'name':
                  feature['text'] ??
                  (category == 'hospital' ? 'Hospital' : 'Posto de Saúde'),
              'address':
                  feature['place_name']?.replaceFirst(
                    '${feature['text']}, ',
                    '',
                  ) ??
                  'Endereço não disponível',
              'location': LatLng(coords[1], coords[0]),
              'distance':
                  Geolocator.distanceBetween(lat, lng, coords[1], coords[0]) /
                  1000,
              'type': category,
            };
          }).toList(),
        );
      }
    }

    if (!mounted) return;

    setState(() {
      _healthUnits =
          allResults..sort((a, b) => a['distance'].compareTo(b['distance']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SizedBox.expand(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Text(
                        'Unidades de saúde (${_searchRadius}km)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loading ? null : _getCurrentLocation,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            _buildMap(),
                            if (_loading)
                              const Center(child: CircularProgressIndicator()),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: FloatingActionButton.small(
                                onPressed: _getCurrentLocation,
                                child: const Icon(Icons.my_location),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(child: _buildHealthUnitList()),
                ],
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: AppHeader()),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
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

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentPosition ?? LatLng(-23.5505, -46.6333),
        zoom: _initialZoom,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: {'accessToken': 'MAPBOX_TOKEN'},
        ),
        MarkerLayer(
          markers: [
            if (_currentPosition != null)
              Marker(
                point: _currentPosition!,
                width: 40,
                height: 40,
                builder:
                    (ctx) => const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
              ),
            ..._healthUnits.map(
              (unit) => Marker(
                point: unit['location'],
                width: 30,
                height: 30,
                builder:
                    (ctx) => Icon(
                      unit['type'] == 'hospital'
                          ? Icons.local_hospital
                          : Icons.medical_services,
                      color:
                          unit['type'] == 'hospital'
                              ? Colors.red
                              : Colors.green,
                      size: 30,
                    ),
              ),
            ),
          ],
        ),
        CircleLayer(
          circles: [
            if (_currentPosition != null)
              CircleMarker(
                point: _currentPosition!,
                color: Colors.blue.withOpacity(0.1),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
                radius: _searchRadius * 1000,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthUnitList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_healthUnits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              'Nenhuma unidade encontrada em ${_searchRadius}km',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 0,
      ), // Ajusta para ocupar largura máxima
      itemCount: _healthUnits.length,
      itemBuilder: (context, index) {
        final unit = _healthUnits[index];
        return Card(
          margin: EdgeInsets.only(
            bottom: index == _healthUnits.length - 1 ? 16 : 8,
          ),
          child: ListTile(
            leading: Icon(
              unit['type'] == 'hospital'
                  ? Icons.local_hospital
                  : Icons.medical_services,
              color: unit['type'] == 'hospital' ? Colors.red : Colors.green,
            ),
            title: Text(unit['name']),
            subtitle: Text(
              '${unit['type'] == 'hospital' ? 'Hospital' : 'Posto de Saúde'}\n'
              '${unit['address']}\n'
              'Distância: ${unit['distance'].toStringAsFixed(1)} km',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () {
                _mapController.move(unit['location'], _initialZoom);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Centralizado em ${unit['name']}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
