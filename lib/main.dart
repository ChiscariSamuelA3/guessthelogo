import 'package:flutter/material.dart';
import 'routes/route_generator.dart';

void main() {
  runApp(const GuessTheLogoApp());
}

class GuessTheLogoApp extends StatelessWidget {
  const GuessTheLogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}