import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../screens/welcome_screen.dart';
import '../screens/game_screen.dart';
import '../screens/highscore_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.game:
        return MaterialPageRoute(builder: (_) => const GameScreen());
      case AppRoutes.highscore:
        return MaterialPageRoute(builder: (_) => const HighScoreScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}