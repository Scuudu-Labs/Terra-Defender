import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/terra_defender.dart';

class SolarBuilding extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  final String buildingName;
  SolarBuilding({this.buildingName = "SolarBuilding", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    priority = 10;


    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: size,
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Buildings/$buildingName.png"), SpriteAnimationData.sequenced(amount: 1, stepTime: stepTime, textureSize: Vector2.all(96)));

    return super.onLoad();
  }

    
  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;

    //   game.trashCount --;
    //   // if(game.playSounds){FlameAudio.play("collect_fruit.wav", volume: game.soundVolume);}
    // //  animation = SpriteAnimation.fromFrameData(game.images.fromCache("Items/Fruits/Collected.png"), SpriteAnimationData.sequenced(amount: 6, stepTime: stepTime, loop: false ,textureSize: Vector2.all(32)));
    // //  await animationTicker?.completed;
    // game.logger.d("Trash Count ${game.trashCount}");

    //  removeFromParent();

    }
  }

  void gotHit(){
    game.logger.d("Building Hit");
    
  }


}