import 'package:flutter/material.dart';
import 'package:myapp/views/planet_detail_screen.dart';
import 'package:provider/provider.dart';
import '../view_models/planet_view_model.dart';
import '../models/planet.dart';
import 'planet_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _planetsFuture;

  @override
  void initState() {
    super.initState();
    _planetsFuture =
        Provider.of<PlanetProvider>(context, listen: false).fetchPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planetas')),
      body: FutureBuilder(
        future: _planetsFuture, // Usa o Future armazenado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Trata erros
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Consumer<PlanetProvider>(
              builder: (context, planetProvider, child) {
                return planetProvider.planets.isEmpty
                    ? Center(child: Text('Nenhum planeta cadastrado.'))
                    : ListView.builder(
                      itemCount: planetProvider.planets.length,
                      itemBuilder: (context, index) {
                        final planet = planetProvider.planets[index];
                        return ListTile(
                          title: Text(planet.name),
                          subtitle: Text(planet.nickname ?? 'Sem apelido'),
                          onTap: () => _navigateToDetail(planet),
                          trailing: Wrap(
                            spacing: 6,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editPlanet(context, planet),
                              ), // icon-1
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed:
                                    () => _confirmDelete(context, planet.id!),
                              ), // icon-2
                            ],
                          ),
                        );
                      },
                    );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addPlanet(context),
      ),
    );
  }

  void _navigateToDetail(Planet planet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanetDetailScreen(planet: planet),
      ),
    ).then(
      (_) => Provider.of<PlanetProvider>(context, listen: false).fetchPlanets(),
    );
  }

  void _addPlanet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanetFormScreen()),
    ).then((_) {
      // Atualiza a lista após adicionar
      Provider.of<PlanetProvider>(context, listen: false).fetchPlanets();
    });
  }

  void _editPlanet(BuildContext context, Planet planet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanetFormScreen(planet: planet)),
    ).then((_) {
      // Atualiza a lista após editar
      Provider.of<PlanetProvider>(context, listen: false).fetchPlanets();
    });
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Excluir planeta?'),
            content: Text('Tem certeza que deseja excluir este planeta?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: Text('Excluir', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Provider.of<PlanetProvider>(
                    context,
                    listen: false,
                  ).deletePlanet(context, id);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
    );
  }
}
