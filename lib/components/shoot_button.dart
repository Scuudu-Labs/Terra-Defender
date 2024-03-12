import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/terra_defender.dart';

class ShootButton extends SpriteComponent with HasGameRef<TerraDefender>, TapCallbacks{
  ShootButton();
  final margin = 32;
  final double buttonSize = 200; // Adjusted button size
  final paddingX = 50; // Added padding
  final paddingY = 0; // Added padding
  double gameWidth = 1280.00;
  double gameHeight = 704.00;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    sprite = Sprite(game.images.fromCache("HUD/ShootButton.png"));
    size = Vector2.all(buttonSize);
    position = Vector2(
      gameWidth - margin - buttonSize - paddingX, // Adjusted position for bottom right
      gameHeight - margin - buttonSize - paddingY,
    );

    priority = 10;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // game.player.hasJumped = true;
    // game.zaWarudoo.fireBullet(game.player, const Duration(seconds: 3), BulletType.player);

          if (!game.zaWarudoo.isFiringBullet) {
        game.zaWarudoo.isFiringBullet = true;
        
      game.zaWarudoo.fireBullet(game.player, const Duration(seconds: 3), BulletType.player);

      Future.delayed(Duration(milliseconds: game.zaWarudoo.shootDelay), (){game.zaWarudoo.isFiringBullet = false;});
          
      }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
