import 'package:flutter/material.dart';
import 'package:terra_defender/terra_defender.dart';

class InDevelopment extends StatelessWidget {
  // Reference to parent game.
  final TerraDefender game;
  const InDevelopment({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 704,
          width: 1280,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background/inDevelopment.png'), // Path to your image file
              fit: BoxFit.cover,
            ),
           
            
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              const SizedBox(height: 250),
              SizedBox(
                width: 400,
                height: 75,
                child: ElevatedButton(

                  onPressed: () {

                    game.overlays.add('MainMenu');
                    game.overlays.remove('InDevelopment');

                  },

                  child: const Text(
                    'Return To Main Menu',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
