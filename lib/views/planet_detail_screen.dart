import 'package:flutter/material.dart';
import '../models/planet.dart';

class PlanetDetailScreen extends StatelessWidget {
  final Planet planet;

  const PlanetDetailScreen({Key? key, required this.planet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planet.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${planet.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Apelido: ${planet.nickname!.isNotEmpty ? planet.nickname : "Nenhum"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Distância do Sol: ${planet.distance} UA',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Tamanho: ${planet.size} km', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
