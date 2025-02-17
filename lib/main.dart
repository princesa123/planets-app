import 'package:flutter/material.dart';
import 'package:myapp/views/home_screen.dart';
import 'views/planet_form_screen.dart';
import 'package:provider/provider.dart';
import 'view_models/planet_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      // Adiciona o contexto para mudar os dados dinamicamente
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlanetProvider()..fetchPlanets(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// Lista para as rotas da aplicação
final Map<String, WidgetBuilder> routes = {
  '/add-planet': (context) => PlanetFormScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Planetas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define a tela inicial da aplicação e adiciona as rotas
      home: HomeScreen(),
      routes: routes,
    );
  }
}
