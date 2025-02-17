import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myapp/services/database_helper.dart'; // Importe o caminho correto
import 'package:myapp/models/planet.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper dbHelper; // Declare dbHelper aqui

  setUp(() async {
    dbHelper = DatabaseHelper.instance; // Inicialize dbHelper no setUp
  });

  tearDown(() async {
    await dbHelper.closeDatabase(); // Use dbHelper para fechar o banco
  });

  test('Insere um planeta e verifica se foi salvo corretamente', () async {
    final planet = Planet(
      name: 'Terra',
      distance: 1.0,
      size: 12742,
      nickname: 'Azul',
    );

    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    final planets = await dbHelper.getAllPlanets(); // Use getAllPlanets
    expect(planets.length, 1);
    expect(planets.first.id, id); // Verifique se o ID inserido corresponde
    expect(planets.first.name, 'Terra');
  });

  test('Atualiza um planeta e verifica a modificação', () async {
    final planet = Planet(
      name: 'Marte',
      distance: 1.5,
      size: 6779,
      nickname: 'Vermelho',
    );
    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    final updatedPlanet = Planet(
      id: id, // Use o ID retornado por insertPlanet
      name: 'Marte',
      distance: 1.52,
      size: 6800,
      nickname: 'Planeta Vermelho',
    );
    await dbHelper.updatePlanet(updatedPlanet);

    final planets = await dbHelper.getAllPlanets();
    expect(planets.length, 1);
    expect(planets.first.distance, 1.52);
    expect(planets.first.nickname, 'Planeta Vermelho');
  });

  test('Remove um planeta e verifica se foi apagado', () async {
    final planet = Planet(
      name: 'Júpiter',
      distance: 5.2,
      size: 139820,
      nickname: 'Gigante',
    );
    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    await dbHelper.deletePlanet(id); // Use o ID retornado por insertPlanet
    final planets = await dbHelper.getAllPlanets();
    expect(planets.isEmpty, true);
  });
}
