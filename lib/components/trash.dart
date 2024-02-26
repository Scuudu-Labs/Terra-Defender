import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/terra_defender.dart';

class Trash extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  final String trash;
  Trash({this.trash = "trash", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    game.trashCount ++;


    priority = 10;


    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2.all(50),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Trash/$trash.png"), SpriteAnimationData.sequenced(amount: 12, stepTime: stepTime, textureSize: Vector2.all(96)));

    return super.onLoad();
  }

    
  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;

      game.trashCount --;
      // if(game.playSounds){FlameAudio.play("collect_fruit.wav", volume: game.soundVolume);}
    //  animation = SpriteAnimation.fromFrameData(game.images.fromCache("Items/Fruits/Collected.png"), SpriteAnimationData.sequenced(amount: 6, stepTime: stepTime, loop: false ,textureSize: Vector2.all(32)));
    //  await animationTicker?.completed;
    game.logger.d("Trash Count ${game.trashCount}");
    checkTrashCollected();

     removeFromParent();

    }

 
  }

      void checkTrashCollected(){
      if (game.trashCount <= 0) {

        Future.delayed(const Duration(milliseconds: 1500), (){
          //Enable Building By bringing it to the front
        game.zaWarudoo.solarBuilding.priority = 10;
        });
        
        game.logger.d("Building Created");
      }
    }
}