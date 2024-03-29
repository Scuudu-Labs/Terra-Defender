import 'package:flutter/material.dart';
import 'package:terra_defender/terra_defender.dart';

class GameOver extends StatelessWidget {
  // Reference to parent game.
  final TerraDefender game;
  const GameOver({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: screenSize.height,
          width: screenSize.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background/gameOver.png'), // Path to your image file
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 250),
              GestureDetector(
                onTap: () {
                  if (game.canPlaySound) {
                    game.playSound("onPickup");
                  }
                  game.restartGame();
                },
                child: Image.asset(
                  'assets/images/Background/playAgain.png',
                  width: 150, // Adjusted width for the play button image
                  height: 75, // Adjusted height for the play button image
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
