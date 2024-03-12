import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/components/enemy.dart';
import 'package:terra_defender/components/particle.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/solarBuilding.dart';
import 'package:terra_defender/components/tree.dart';
import 'package:terra_defender/terra_defender.dart';

enum BulletType {player, towerDestroyer, deforester, trasher, airPolluter, noisePolluter}

class Bullet extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{

    Bullet({super.position, super.size, this.bulletType = BulletType.player, this.isShootingLeft = false, this.bulletMoveSpeed = 100 , this.timeBeforeDestroy = const Duration(seconds: 2)});

    bool isShootingLeft = false;
    double bulletHorizontalMove = 0;
    double bulletMoveSpeed;
    Duration timeBeforeDestroy;
    BulletType bulletType;

    late SpriteAnimationComponent bulletSprite;
  
    Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad()  async {
    // debugMode = true;

    priority = 11;
    
    // size = Vector2.all(15);
    // size = Vector2.all(25);
     add(CircleHitbox());
   setBulletSprite();
    
    destroyAfterSecs();
    return super.onLoad();
  }

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

      //Removes the bullet
      game.zaWarudoo.spawnParticle(other.center, Vector2.all(64));
      removeFromParent();
    }
    if (other is Player) {
      other.gotHit();

      //Removes the bullet
      game.zaWarudoo.spawnParticle(other.center, Vector2.all(64));
      removeFromParent();
    }
    if (other is SolarBuilding) {
      other.gotHit();

      //Removes the bullet
      game.zaWarudoo.spawnParticle(other.center, Vector2.all(64));
      // game.logger.d(other.size);
      removeFromParent();
    }
    if (other is Tree) {
      other.gotHit();

      //Removes the bullet
      game.zaWarudoo.spawnParticle(other.center, Vector2.all(64));
      removeFromParent();
    }
    if (other is Bullet) {
      // other.gotHit();

      //Removes the bullet
      game.zaWarudoo.spawnParticle(other.center, Vector2.all(64));
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _updateBulletMovement(dt){
    
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

  void setBulletSprite() async {
    switch (bulletType) {
      case BulletType.player:
         animation = await game.loadSpriteAnimation(
      'Characters/John/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(2388, 1010),
      ),
    );

    if (game.canPlaySound) {game.playSound("shoot");}
        break;

        case BulletType.trasher:
                 animation = await game.loadSpriteAnimation(
      'Enemies/Trasher/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(986, 488),
        ));

    if (game.canPlaySound) {game.playSound("shoot");}
        break;

        case BulletType.towerDestroyer:
                 animation = await game.loadSpriteAnimation(
      'Enemies/Trasher/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(986, 488),
        ));
    if (game.canPlaySound) {game.playSound("shoot");}
        break;

        case BulletType.airPolluter:
                 animation = await game.loadSpriteAnimation(
      'Enemies/AirPolluter/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(986, 488),
        ));
    if (game.canPlaySound) {game.playSound("shoot");}
        break;

        case BulletType.noisePolluter:
                 animation = await game.loadSpriteAnimation(
      'Enemies/Noisers/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(986, 488),
        ));
    if (game.canPlaySound) {game.playSound("shoot");}
        break;

        case BulletType.deforester:
                 animation = await game.loadSpriteAnimation(
      'Enemies/Deforester/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.05,
        amount: 1,
        textureSize: Vector2(986, 488),
        ));
    if (game.canPlaySound) {game.playSound("shoot");}
        break;

      default:
    }
  }
  
}