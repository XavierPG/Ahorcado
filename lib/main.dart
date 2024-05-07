import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  List<String> words = [
    'BENITO',
    'KAROL',
    'FEID',
    'MORA',
    'LOLIS',
    'DAVIS',
    'XAVI',
    'VAL'
  ];
  String secretWord = '';
  String displayWord = '';
  int maxAttempts = 6;
  int attemptsLeft = 6;
  List<String> guessedLetters = [];

  @override
  void initState() {
    super.initState();
    selectRandomWord();
    initializeDisplayWord();
  }

  void selectRandomWord() {
    final random = Random();
    secretWord = words[random.nextInt(words.length)];
  }

  void initializeDisplayWord() {
    displayWord = secretWord.replaceAll(RegExp(r'[A-Z]'), '_');
  }

  void checkLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        guessedLetters.add(letter);
        if (!secretWord.contains(letter)) {
          attemptsLeft--;
        } else {
          for (int i = 0; i < secretWord.length; i++) {
            if (secretWord[i] == letter) {
              displayWord = displayWord.replaceRange(i, i + 1, letter);
            }
          }
          if (displayWord == secretWord) {
            showCongratulationsDialog();
          }
        }
        if (attemptsLeft == 0) {
          showGameOverDialog();
        }
      }
    });
  }

  void showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡FELICIDADES!'),
          content: Text('¡Has adivinado la palabra correctamente!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Volver a jugar'),
            ),
          ],
        );
      },
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡PERDISTE!'),
          content:
              Text('Se acabaron los intentos. La palabra era $secretWord.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Volver a intentar'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      selectRandomWord();
      initializeDisplayWord();
      attemptsLeft = 6;
      guessedLetters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Intentos restantes: $attemptsLeft',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Palabra: $displayWord',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    9,
                    (index) {
                      String letter =
                          String.fromCharCode('A'.codeUnitAt(0) + index);
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLetter(letter);
                          },
                          child: Text(letter),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    9,
                    (index) {
                      String letter =
                          String.fromCharCode('J'.codeUnitAt(0) + index);
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLetter(letter);
                          },
                          child: Text(letter),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    8,
                    (index) {
                      String letter =
                          String.fromCharCode('S'.codeUnitAt(0) + index);
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLetter(letter);
                          },
                          child: Text(letter),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
