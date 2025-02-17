import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../services/database_helper.dart';

class PlanetProvider extends ChangeNotifier {
  // Cria a lista de planetas
  List<Planet> _planets = [];

  List<Planet> get planets => _planets;

  // Retorna uma lista de planetas do banco através da service
  Future<void> fetchPlanets() async {
    _planets = await DatabaseHelper.instance.getAllPlanets();
    notifyListeners();
  }

  // Adiciona um planeta no banco através da service
  Future<void> addPlanet(BuildContext context, Planet planet) async {
    await DatabaseHelper.instance.insertPlanet(planet);
    _planets.add(planet);
    notifyListeners();
    _showSnackbar(context, 'Planeta adicionado com sucesso!');
  }

  // Atualiza um planeta no banco através da service
  Future<void> updatePlanet(BuildContext context, Planet planet) async {
    await DatabaseHelper.instance.updatePlanet(planet);
    final index = _planets.indexWhere((p) => p.id == planet.id);
    if (index != -1) {
      _planets[index] = planet;
      notifyListeners();
    }
    _showSnackbar(context, 'Planeta atualizado com sucesso!');
  }

  // Apaga um planeta do banco através da service
  Future<void> deletePlanet(BuildContext context, int id) async {
    await DatabaseHelper.instance.deletePlanet(id);
    _planets.removeWhere((planet) => planet.id == id);
    notifyListeners();
    _showSnackbar(context, 'Planeta excluído com sucesso!');
  }

  // Feedback visual para ações realizadas
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
