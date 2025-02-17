import 'package:flutter/material.dart';
import 'package:myapp/views/home_screen.dart';
import 'views/planet_form_screen.dart';
import 'package:provider/provider.dart';
import 'view_models/planet_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlanetProvider()..fetchPlanets(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

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
      home: HomeScreen(),
      routes: routes,
    );
  }
}
