import 'package:flutter/material.dart';
import 'package:terra_defender/terra_defender.dart';

class MainMenu extends StatelessWidget {
  final TerraDefender game;
  const MainMenu({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background/mainMenu.png'), // Path to your image file
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              // padding: const EdgeInsets.only(top: 50), // Adjusted padding for the logo
              padding: const EdgeInsets.only(top: 0), // Adjusted padding for the logo
              child: Container(
                width: 500, // Adjusted width for the logo
                height: 250, // Adjusted height for the logo
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Background/logo.png'),
                    fit: BoxFit.contain, // Adjusted to fit the container
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                // Remove the main menu overlay and start the game
                
                // game.overlays.remove('MainMenu');
                game.startGame();
                
                // Additional code to start the game goes here
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent), // Remove background color
                elevation: MaterialStateProperty.all(0), // Remove shadow
                overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove overlay color
              ),
              child: Image.asset(
                'assets/images/Background/playButton.png',
                width: 150, // Adjusted width for the play button image
                height: 75, // Adjusted height for the play button image
              ),
              // Adjusted button text
            ),
            // Add more buttons/options here
          ],
        ),
      ),
    );
  }
}
