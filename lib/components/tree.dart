import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/terra_defender.dart';

class Tree extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  final String treeName;
  Tree({this.treeName = "tree", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);

  double treeHealth = 12;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    priority = 10;


    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: size,
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Trees/$treeName.png"), SpriteAnimationData.sequenced(amount: 12, stepTime: stepTime, textureSize: Vector2.all(96)));

    return super.onLoad();
  }

    


  void gotHit(){
    // game.logger.d("Tree Hit");
    if(game.canPlaySound){game.playSound("attackeeHit");}

    treeHealth --;

    if (treeHealth <= 0) {
      game.zaWarudoo.solarBuildings.remove(this);
      removeFromParent();
    }
    
  }


}