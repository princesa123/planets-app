// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';
import 'package:myapp/view_models/planet_view_model.dart';
import 'package:myapp/views/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final planetProvider = PlanetProvider();

    // Envolva o widget que você está testando com o Provider
    await tester.pumpWidget(
      ChangeNotifierProvider<PlanetProvider>(
        create: (context) => planetProvider,
        child: MaterialApp(
          // Ou seu widget raiz
          home: HomeScreen(), // O widget que você está testando
        ),
      ),
    );
  });
}
