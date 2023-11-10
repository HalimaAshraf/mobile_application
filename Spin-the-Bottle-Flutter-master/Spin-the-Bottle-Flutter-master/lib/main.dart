import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottle spinner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Screen1(),
    );
  }
}

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  var rng = Random();
  double _rotationAngle = 0.0;
  bool _isCompleted = false;
  int _winnerPlayer = 0;
  int _numberOfPlayers = 10;
  List<String> _playerNames = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
    'Player 6',
    'Player 7',
    'Player 8',
    'Player 9',
    'Player 10',
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  void _startRotation() {
    setState(() {
      _rotationAngle = rng.nextDouble() * 10 + 2; // Random number of rotations between 2 and 12
      _isCompleted = false;
      _winnerPlayer = 0;
      _animationController.reset();
      _animationController.forward().then((_) {
        _showWinner();
      });
    });
  }

  void _showWinner() {
    setState(() {
      _isCompleted = true;
      _winnerPlayer = rng.nextInt(_numberOfPlayers) + 1;
      double playerAngle = (2 * pi / _numberOfPlayers) * (_winnerPlayer - 1);
      _rotationAngle = playerAngle + (2 * pi * rng.nextDouble()); // Randomize the final angle within the player's range
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNumberOfPlayersChanged(double value) {
    setState(() {
      _numberOfPlayers = value.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "images/floor.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _startRotation,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: _rotationAngle).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.linear,
                  ),
                ),
                child: Image.asset(
                  "images/bottle.png",
                  height: 150,
                  width: 300,
                ),
              ),
            ),
          ),
          for (int i = 1; i <= _numberOfPlayers; i++)
            Positioned(
              top: 290 + 120 * cos(2 * pi * i / _numberOfPlayers),
              left: 215 + 120 * sin(2 * pi * i / _numberOfPlayers),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _playerNames[i - 1],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          if (_isCompleted)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Winner: ${_playerNames[_winnerPlayer - 1]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Text(
                  'Number of Players:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Slider(
                    value: _numberOfPlayers.toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 10,
                    onChanged: _onNumberOfPlayersChanged,
                  ),
                ),
                Text(
                  _numberOfPlayers.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
