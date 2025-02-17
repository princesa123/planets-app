import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/services/database_helper.dart';
import 'package:myapp/models/planet.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inicia o banco para testes
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = DatabaseHelper.instance;
  });

  tearDown(() async {
    // Encerra o banco para testes
    await dbHelper.closeDatabase();
  });

  test('Insere um planeta e verifica se foi salvo corretamente', () async {
    final planet = Planet(
      name: 'Terra',
      distance: 1.0,
      size: 12742,
      nickname: 'Azul',
    );

    // Atualiza no banco
    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    // Verifica se o planeta retornado é o mesmo inserido
    final planets = await dbHelper.getAllPlanets();
    expect(planets.length, 1);
    expect(planets.first.id, id);
    expect(planets.first.name, 'Terra');
  });

  test('Atualiza um planeta e verifica a modificação', () async {
    final planet = Planet(
      name: 'Marte',
      distance: 1.5,
      size: 6779,
      nickname: 'Vermelho',
    );
    // Insere no banco
    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    // Cria outro com mesmo ID
    final updatedPlanet = Planet(
      id: id,
      name: 'Marte',
      distance: 1.52,
      size: 6800,
      nickname: 'Planeta Vermelho',
    );

    // Atualiza no banco
    await dbHelper.updatePlanet(updatedPlanet);

    // Verifica se o planeta retornado é o mesmo inserido
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
    // Insere no banco
    int id = await dbHelper.insertPlanet(planet);
    expect(id, isNonZero);

    // Apaga no banco
    await dbHelper.deletePlanet(id);
    // Tenta encontrar no banco
    final planets = await dbHelper.getAllPlanets();
    expect(planets.isEmpty, true);
  });
}
