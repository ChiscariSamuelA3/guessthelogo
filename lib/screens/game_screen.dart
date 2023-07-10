import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import '../models/logo.dart';
import '../widgets/logo_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Logo> logoList = [];
  int totalLength = 0;
  int score = 0;
  int lives = 3;
  Logo? currentLogo;
  TextEditingController controller = TextEditingController();
  late Future<void> loadLogosFuture;

  @override
  void initState() {
    super.initState();
    loadLogosFuture = loadLogos();
  }

  Future<void> loadLogos() async {
    // getting the list of images from the assets folder
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // extract the image names from the manifest map
    final imageNames = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.png'))
        .toList();

    // shuffling the list of image names
    imageNames.shuffle();

    // create the logo list
    for (int i = 0; i < imageNames.length; i++) {
      logoList.add(Logo(
        name: imageNames[i].replaceAll('assets/', '').replaceAll('.png', ''),
        imagePath: imageNames[i],
      ));
    }

    totalLength = logoList.length;

    currentLogo = logoList.removeLast();
  }

  void checkAnswer(String answer) async {
    if (answer.toLowerCase() == currentLogo?.name) {
      // Correct answer
      setState(() {
        score++;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int highscore = prefs.getInt('highscore') ?? 0;

      if (score > highscore) {
        // New highscore
        await prefs.setInt('highscore', score);
      }
    } else {
      // Incorrect answer
      setState(() {
        lives--;
      });

      // Game over
      if (lives == 0) {
        await showEndGameMessage('Game Over! Your final score is $score');
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.highscore);
        }
      }
    }

    controller.clear();

    // Load the next logo
    if (logoList.isNotEmpty) {
      setState(() {
        currentLogo = logoList.removeLast();
      });
    } else {
      await showEndGameMessage(
          'Congratulations! You have guessed all the logos. Your final score is $score');
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.highscore);
      }
    }
  }

  Future<void> showEndGameMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End of Game'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadLogosFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return loading indicator while the future is not completed
          return const Center(child: CircularProgressIndicator());
        } else {
          // Once the future has completed, return the widget tree
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Lives: $lives",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Score: $score/$totalLength",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ),
                      LogoCard(logo: currentLogo!),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: "Guess the logo",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => checkAnswer(controller.text),
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
