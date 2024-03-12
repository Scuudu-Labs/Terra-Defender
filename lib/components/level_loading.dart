import 'package:flutter/material.dart';
import 'package:terra_defender/terra_defender.dart';

class LevelCleared extends StatelessWidget {
  // Reference to parent game.
  final TerraDefender game;
  const LevelCleared({Key? key, required this.game}) : super(key: key);

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
              image: AssetImage('assets/images/Background/loadingLevel.png'), // Path to your image file
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // No need for the GestureDetector and Image.asset for the play button
            ],
          ),
        ),
      ),
    );
  }
}
