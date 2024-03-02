import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:terra_defender/components/enemy.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/solarBuilding.dart';
import 'package:terra_defender/terra_defender.dart';

class Bullet extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{

    Bullet({super.position,this.isShootingLeft = false, this.bulletMoveSpeed = 100 , this.timeBeforeDestroy = const Duration(seconds: 3)});

    bool isShootingLeft = false;
    double bulletHorizontalMove = 0;
    double bulletMoveSpeed;
    Duration timeBeforeDestroy;

    late SpriteAnimationComponent bulletSprite;

  
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad()  async {
    debugMode = true;
    // position.x = game.player.startPos.x + game.player.width;
    // position.y = game.player.startPos.y + game.player.height/2;
    // position = game.player.position;
    // addToParent(game.zaWarudoo);

    priority = 11;
    
    // size = Vector2.all(15);
    size = Vector2.all(25);
     add(CircleHitbox());
    animation = await game.loadSpriteAnimation(
      'Characters/John/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(2388, 1010),
      ),
    );
    
    destroyAfterSecs();

    

    
    return super.onLoad();
  }

  // @override
  // FutureOr<void> addToParent(Component parent) {
  //   assert(parent is World, );
  //   return super.addToParent(parent);
  // }

  @override
  void update(double dt) {
    _updateBulletMovement(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) 
  {
    if (other is Enemy) {
      other.gotHit();
      removeFromParent();
    }
    if (other is Player) {
      other.gotHit();
      removeFromParent();
    }
    if (other is SolarBuilding) {
      other.gotHit();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _updateBulletMovement(dt){

    // bulletHorizontalMove = isShootingLeft ? -1 : 1;
    // bulletHorizontalMove = -1;
    
    if (isShootingLeft) {
      bulletHorizontalMove = -1;
    } else {
      bulletHorizontalMove = 1;
    }

    velocity.x = bulletHorizontalMove * bulletMoveSpeed;
    position.x += velocity.x * dt;
  }

  void destroyAfterSecs(){
    Future.delayed(timeBeforeDestroy, (){removeFromParent();});
  }
  
}