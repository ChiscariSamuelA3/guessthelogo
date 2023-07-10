import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../routes/app_routes.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  int? highscore;

  @override
  void initState() {
    super.initState();
    loadHighScore();
  }

  void loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = prefs.getInt('highscore') ?? 0;
    });
  }

  void resetHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highscore', 0);
    loadHighScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.deepPurple,
            Colors.redAccent,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Highscore is $highscore",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        color: Color.fromARGB(125, 0, 0, 255),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start New Game'),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.game),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Highscore'),
                  onPressed: resetHighScore,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(5),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15)),
                  )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share Your Score'),
                  onPressed: () {
                    Share.share(
                        'Check out my highscore on Guess The Logo: $highscore!');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(5),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15)),
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}
