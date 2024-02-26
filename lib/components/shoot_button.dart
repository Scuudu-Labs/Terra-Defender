import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:terra_defender/terra_defender.dart';

class ShootButton extends SpriteComponent with HasGameRef<TerraDefender>, TapCallbacks{
  ShootButton();
  final margin = 32;
  final buttonSize = 64;


  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    sprite = Sprite(game.images.fromCache("HUD/ShootButton.png"));
    size = Vector2.all(70);
    // position = Vector2(560, 270);
    position = Vector2(
      game.size.x - margin - buttonSize, 
      game.size.y -margin -buttonSize,
    );


    priority = 10;

    return super.onLoad();
  }

@override
  void onTapDown(TapDownEvent event) {
    // game.player.hasJumped = true;
    game.zaWarudoo.fireBullet();
    super.onTapDown(event);
  }

@override
  void onTapUp(TapUpEvent event) {
    // game.player.hasJumped = false;
    super.onTapUp(event);
  }

}