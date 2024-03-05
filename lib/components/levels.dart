import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:terra_defender/components/Text_display.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/collision_block.dart';
import 'package:terra_defender/components/enemy.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/solarBuilding.dart';
import 'package:terra_defender/components/trash.dart';
import 'package:terra_defender/components/tree.dart';
import 'package:terra_defender/terra_defender.dart';

class Levels extends World with HasGameRef<TerraDefender>, KeyboardHandler {
  Levels({required this.levelName, required this.player});

  final String levelName;
  final Player player;

  late TiledComponent level;

  bool isFiringBullet = false;
  bool isFiringLeft = false;

  //Milliseconds between bullet shots
  double fireRate = 300;

  //Storing the collision blocks
  List<CollissionBlock> collissionBlocks = [];

  List<Vector2> enemySpawnPoints = [];
  List<Vector2> enemysize = [];


  List<Vector2> solarBuildingSpawnPoints = [];

  List<SolarBuilding> solarBuildings = [];

  List<Vector2> treeSpawnPoints = [];
  List<Tree> trees = [];



  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      "$levelName.tmx",
      Vector2.all(32),
    );
    // debugMode = true;

    add(level);

    _spawnObjects();
    _addCollissions();
    // add(ScreenHitbox());

    priority = 10;
    //Sets the collission blocks from the level file in the collission block List on the player file
    player.collissionBlocks = collissionBlocks;

    return super.onLoad();
  }

  @override
  void update(double dt) {


    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    
    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      fireBullet(player, const Duration(seconds: 3), BulletType.player);
    } 

    return super.onKeyEvent(event, keysPressed);
  }

  void fireBullet(PositionComponent shooter, Duration timeBeforeDestroy, BulletType bulletType){

    //Right bullet path
    final posR = Vector2(shooter.x - shooter.width, shooter.y + shooter.height / 2);
    //Left bullet path
    final posL = Vector2(shooter.x + shooter.width, shooter.y + shooter.height / 2);

    late final Vector2 pos;
    late bool shootLeft = shooter.scale.x < 0;

    if (shootLeft) {
      pos = posR;
    } else{
      pos = posL;
    }

    final bullet = Bullet(
        isShootingLeft: shootLeft,
        position: pos,
        timeBeforeDestroy: timeBeforeDestroy,
        bulletMoveSpeed: fireRate,
        bulletType: bulletType
        );

    bullet.scale.x = shooter.scale.x;

    add(bullet);
  }

  void spawnEnemyDrop(PositionComponent dropper){
    add(Trash(
      position: dropper.position,
      size: Vector2.all(64),
    ));
  }

  //Spaen in objects based on the position ifo gotten from the TIled.tmx file
  void _spawnObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>("SpawnPoints");

    if (game.currentLevelIndex > 0) {
      spawnText("Protect The Trees");
    }

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.size = Vector2(spawnPoint.width, spawnPoint.height);

            player.scale.x = 1;

            add(player);

            break;
          case "Enemy":

          enemySpawnPoints.add(Vector2(spawnPoint.x, spawnPoint.y));
          enemysize.add(Vector2(spawnPoint.width, spawnPoint.height));

          if(game.currentLevelIndex > 0){
           late String enemyNam = spawnPoint.name;

            if (enemyNam == "Noisers") {
                          add(Enemy(enemyType: EnemyType.noisePolluter,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: 10,
              offPos: 10,
            ));
            }
          }

            // add(Enemy(enemyType: EnemyType.noisePolluters,
            //   position: Vector2(spawnPoint.x, spawnPoint.y),
            //   size: Vector2(spawnPoint.width, spawnPoint.height),
            //   offNeg: 10,
            //   offPos: 10,
            // ));

            break;

          case "Trash":
            
            // game.logger.d(   Vector2(spawnPoint.x, spawnPoint.y),Vector2(spawnPoint.width, spawnPoint.height),);
            add(Trash(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            ));

            break;

          case "SolarBuilding":

          if(game.currentLevelIndex <= 0){
            solarBuildingSpawnPoints.add(Vector2(spawnPoint.x, spawnPoint.y));
          }
          else{
            add(SolarBuilding(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
      
      ));
          }

          break;

          case "Tree":
          if(game.currentLevelIndex > 0){
                      // treeSpawnPoints.add(Vector2(spawnPoint.x, spawnPoint.y));
                      final treez = Tree(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2.all(96),
              );
              trees.add(treez);
          add(treez);
          }
          
          break;

          case "TextPrompt":
            add(Typewriter(
              textToType: "Pick Up the Trash",
              // position: Vector2(spawnPoint.x, spawnPoint.y),
              position: Vector2(game.size.x / 2, game.size.y / 15),
              typingSpeed: const Duration(milliseconds: 70),
              destroyOnTypeCompleted: true,
              destroyAfterDuration: const Duration(seconds: 6),
            ));
            break;
          default:
        }
      }
    }
  }

  void _addCollissions() {
    //Gets the layers for the collision
    final collissionLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");

    if (collissionLayer != null) {
      for (final collision in collissionLayer.objects) {
        switch (collision.class_) {
          //Checks for platform class tag
          case "Platform":
            final platform = CollissionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );

            collissionBlocks.add(platform);

            add(platform);
            break;
          default:
          // //The remaining non platform blocks
          //   final block = CollissionBlock(
          //     position: Vector2(collision.x, collision.y),
          //     size: Vector2(collision.width, collision.height),
          //   );
          //   game.logger.d("Col Added");
          //   collissionBlocks.add(block);
          //   add(block);
        }
      }
    }
  }

  void protectTowerPrompt(){

            add(Typewriter(
              textToType: "Protect the Solar Tower",
              // position: Vector2(player.position.x, player.position.y + (player.size.y * 2)),
              position: Vector2(game.size.x / 2, game.size.y / 15),
              typingSpeed: const Duration(milliseconds: 70),
              destroyOnTypeCompleted: true,
              destroyAfterDuration: const Duration(seconds: 3),
          ));


          //Wait for prompt 
           Future.delayed(const Duration(seconds: 5), (){

            for (var spPoint in enemySpawnPoints) {
              // for (var eSiz in enemysize) {
                spawnEnemy(EnemyType.towerDestroyer, spPoint, Vector2.all(96));
              // }
            }

        });


  }

  //ProtectType: solar tower, trees
  // Put in a list of attackables, make enemy attack the closest one to it 

  void spawnAttackee(){

    if (solarBuildingSpawnPoints.isNotEmpty) {

      final solBuild = SolarBuilding(
      position: solarBuildingSpawnPoints[0],
      size: Vector2.all(160),
    );

    solarBuildings.add(solBuild);

    add(solBuild);

    protectTowerPrompt();

    solarBuildingSpawnPoints.removeAt(0);

      return;
    }
    else{
      spawnText("Level Cleared!!!");

      Future.delayed(const Duration(seconds: 3), (){game.loadNextLevel();});
    }

    // if (trees.isEmpty) {
    //   final tree = Tree(
    //     position: treeSpawnPoints[0],
    //     size: Vector2.all(96),
    //   );

    //   trees.add(tree);

    //   add(tree);
      
    // }

  }

  void spawnEnemy(EnemyType enemyType, Vector2 pos, Vector2 siz){
                add(Enemy(enemyType: enemyType,
              position: pos,
              size: siz,
              offNeg: 10,
              offPos: 10,
            ));
  }

  void collectDroppedResourcesPrompt() {
                add(Typewriter(
              textToType: "Collect Dropped Resources",
              // position: Vector2(player.position.x, player.position.y + (player.size.y * 2)),
              position: Vector2(game.size.x / 2, game.size.y / 15),
              typingSpeed: const Duration(milliseconds: 70),
              destroyOnTypeCompleted: true,
              destroyAfterDuration: const Duration(seconds: 3),
          ));

  }
    void spawnText(String text) {
                add(Typewriter(
              textToType: text,
              // position: Vector2(player.position.x, player.position.y + (player.size.y * 2)),
              position: Vector2(game.size.x / 2, game.size.y / 15),
              typingSpeed: const Duration(milliseconds: 70),
              destroyOnTypeCompleted: true,
              destroyAfterDuration: const Duration(seconds: 3),
          ));

  }
}
