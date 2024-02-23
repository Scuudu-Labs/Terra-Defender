import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/enemy.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/terra_defender.dart';

class Levels extends World with HasGameRef<TerraDefender>, KeyboardHandler {
  Levels({required this.levelName, required this.player});

  final String levelName;
  final Player player;

  late TiledComponent level;

  bool canFireBullet = false;
  bool isFiringBullet = false;
  bool isFiringLeft = false;

  //Milliseconds between bullet shots
  int fireRate = 300;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      "$levelName.tmx",
      Vector2.all(32),
    );

    add(level);

    _spawnObjects();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (player.scale.x > 0) {
      isFiringLeft = false;
    } else if (player.scale.x < 0) {
      isFiringLeft = true;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      canFireBullet = true;
      fireBullet();
    } else {
      canFireBullet = false;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void fireBullet() {
    if (isFiringBullet) {
      return;
    }

    //Right bullet path
    final posR = Vector2(game.player.position.x + player.width,
        game.player.y + game.player.height / 2);
    //Left bullet path
    final posL = Vector2(game.player.position.x - player.width,
        game.player.y + game.player.height / 2);

    late final Vector2 pos;

    if (player.scale.x > 0) {
      pos = posR;
    } else if (player.scale.x < 0) {
      pos = posL;
    }

    final bullet = Bullet(
        isShootingLeft: isFiringLeft,
        position: pos,
        timeBeforeDestroy: const Duration(seconds: 3),
        bulletMoveSpeed: 300);

    bullet.scale.x = player.scale.x;

    add(bullet);

    isFiringBullet = true;

    //Wait for seconds
    Future.delayed(Duration(milliseconds: fireRate), () {
      isFiringBullet = false;
    });

    // logger.wtf("Fired Bullet");
  }

  void _spawnObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>("SpawnPoints");

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
            add(Enemy(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: 10,
              offPos: 10,
            ));
            break;
          default:
        }
      }
    }
  }
}
