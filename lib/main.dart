import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:terra_defender/components/game_over.dart';
import 'package:terra_defender/components/in_development.dart';
import 'package:terra_defender/components/level_loading.dart';
import 'package:terra_defender/components/main_menu.dart';
import 'package:terra_defender/terra_defender.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();

 await Flame.device.fullScreen();

 await Flame.device.setLandscape();



//  TerraDefender game = TerraDefender();

  //  runApp(GameWidget(game: kDebugMode ? TerraDefender() : game));

  //   runApp(
  //   GameWidget<TerraDefender>.controlled(
  //     gameFactory: TerraDefender.new,
  //     overlayBuilderMap: {
  //       'MainMenu': (context, game) => MainMenu(game: game),
  //       // Add other overlays here if needed
  //     },
  //     initialActiveOverlays: const ['MainMenu'],
  //   ),
  // );
    
    runApp(
    GameWidget<TerraDefender>.controlled(
      gameFactory: TerraDefender.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'InDevelopment': (_, game) => InDevelopment(game: game),
        'LevelCleared': (_, game) => LevelCleared(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );


}


