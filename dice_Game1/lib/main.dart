import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DiceGame());
}

class DiceGame extends StatefulWidget {
  @override
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  List<int> playerScores = [0, 0, 0, 0];
  int currentPlayer = 0;
  int totalTurns = 0;
  int diceNumber = 1;
  int winner=0; // Variable to store the winner

  int extraRolls = 0; // Number of extra rolls when a player rolls a 6

  void resetGame() {
    setState(() {
      playerScores = [0, 0, 0, 0];
      currentPlayer = 0;
      totalTurns = 0;
      diceNumber = 1;
      winner = 0; // Reset the winner
      extraRolls = 0;
    });
  }

  void determineWinner() {
    int maxScore = playerScores.reduce(max);
    winner = playerScores.indexOf(maxScore);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: const Text('Dice Game'),
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            for (int player = 0; player < 4; player++)
              Positioned(
                top: player < 2 ? 10 : null,
                bottom: player >= 2 ? 10 : null,
                left: player % 2 == 0 ? 10 : null,
                right: player % 2 != 0 ? 10 : null,
                child: buildPlayerWidget(player + 1, playerScores[player]),
              ),

            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Player ${currentPlayer + 1}\'s Turn',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'Orbitron',
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: totalTurns < 15
                          ? () {
                        setState(() {
                          diceNumber = Random().nextInt(6) + 1;
                          playerScores[currentPlayer] += diceNumber;
                          totalTurns++;

                          if (diceNumber == 6) {
                            // If the player rolls a 6, give them an extra roll
                            extraRolls++;
                          }

                          if (totalTurns == 15 || extraRolls == 2) {
                            determineWinner();
                          } else if (extraRolls == 1) {
                            // Continue with the same player for the extra roll
                            extraRolls = 0;
                          } else {
                            // Switch to the next player
                            currentPlayer = (currentPlayer + 1) % 4;
                          }
                        });
                      }
                          : null,
                      child: const Text(
                        'Roll Dice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Orbitron',
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Image.asset(
                      'images/dice$diceNumber.png',
                      width: 100.0,
                      height: 100.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Total Turns: $totalTurns',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'Orbitron',
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (winner != null)
                      Text(
                        'Player ${winner + 1} wins!',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.yellow,
                          fontFamily: 'Orbitron',
                          letterSpacing: 2.0,
                        ),
                      ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: resetGame,
                      child: const Text(
                        'Reset Game',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerWidget(int playerNumber, int score) {
    return Column(
      children: [
        CircleAvatar(child: Icon(Icons.person)),
        Text(
          'Player $playerNumber',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Orbitron',
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Orbitron',
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
