import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/terra_defender.dart';

class Trash extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  String trash;
  Trash({this.trash = "trash", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool collected = false;



  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    priority = 10;

    game.trashCount ++;


    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2.all(50),
      collisionType: CollisionType.passive,
    ));

    int randNum = game.randomNumberInRange(1,5);

    switch (randNum) {
      case 1:
        trash = "trash";
        break;
      case 2:
        trash = "trashBag";
      break;
      case 3:
        trash = "trashCan";
        break;
      case 4:
        trash = "trashHeap";
        break;
      case 5:
        trash = "trashHeap";
        break;
      default:
    }

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
    // game.logger.d("Trash Count ${game.trashCount}");
    // game.logger.d("Enemy Count ${game.enemyCount}");
    // game.logger.d("Tower COunt ${game.towerCount}");
    // game.logger.d("Level Cleared ${game.levelCleared}");
    checkTrashCollected();

     removeFromParent();

    }
  }

      void checkTrashCollected(){
        ///Spawns Initial Tower
      if (game.trashCount <= 0 && !game.levelCleared) {

        Future.delayed(const Duration(milliseconds: 1500), (){

        game.zaWarudoo.spawnAttackee();


      });}

      if (game.trashCount <= 0 && game.levelCleared == true) {
                
          game.zaWarudoo.spawnAttackee();


      }
    }
}