import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/terra_defender.dart';

class SolarBuilding extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  final String buildingName;
  SolarBuilding({this.buildingName = "solarTower", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 0, width: 6, height: 12);
  bool collected = false;

  double towerHealth = 10;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    priority = 10;

      game.towerCount ++;



    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(size.x / 2, size.y),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Buildings/$buildingName.png"), SpriteAnimationData.sequenced(amount: 1, stepTime: stepTime, textureSize: Vector2.all(96)));

    return super.onLoad();
  }

    
  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;

      game.screenShake(const Duration(milliseconds: 350));

    //   game.trashCount --;
    //   // if(game.playSounds){FlameAudio.play("collect_fruit.wav", volume: game.soundVolume);}
    // //  animation = SpriteAnimation.fromFrameData(game.images.fromCache("Items/Fruits/Collected.png"), SpriteAnimationData.sequenced(amount: 6, stepTime: stepTime, loop: false ,textureSize: Vector2.all(32)));
    // //  await animationTicker?.completed;
    // game.logger.d("Trash Count ${game.trashCount}");

    //  removeFromParent();

    }
  }

  void gotHit(){
    // game.logger.d("Building Hit");
    if(game.canPlaySound){FlameAudio.play("attackeeHit.wav", volume: game.soundVolume);}

    game.screenShake(const Duration(milliseconds: 400));
    
    towerHealth --;

    if (towerHealth <= 0) {

      game.towerCount --;
      
      game.zaWarudoo.solarBuildings.remove(this);

      if (game.towerCount <= 0) {
        // game.loadLevelWithIndex(0);
        game.showGameOverScreen();
      }

      game.zaWarudoo.spawnParticle(center, Vector2.all(64));

      removeFromParent();
    }
    
  }

}