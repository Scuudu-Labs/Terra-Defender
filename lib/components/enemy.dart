import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/solarBuilding.dart';
import 'package:terra_defender/components/tree.dart';
import 'package:terra_defender/terra_defender.dart';

enum State{idle, run, hit}
enum EnemyType{towerDestroyer, trasher, deforester, airPolluter, noisePolluter}

class Enemy extends SpriteAnimationGroupComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  // Chicken({position, size}) : super(position: position, size: size);

  //Shorthand
   Enemy({super.position, super.size, required this.enemyType, this.offNeg = 0, this.offPos = 0,});

  EnemyType enemyType;
  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirectionX = -1;
  double targetDirectionY = -1;
  bool gotStomped = false;
   final double offNeg;
   final double offPos;

   
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const enemyMoveSpeed = 40;
  final textureSize = Vector2(96, 96);

  double rangeNeg = 0;
  double rangePos = 0;

  late final Player player;
  // late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  // late final SpriteAnimation _hitAnimation;

  bool isFiringBulletLeft = false;

  int fireRate = 2500;

  double enemyHealth = 3;

  bool isFiringEnemyBullet = false;

  bool isDead = false;

  late final RectangleHitbox hitbox;

   @override
  FutureOr<void> onLoad() {
    game.enemyCount ++;
    game.levelCleared == false;

    // debugMode = true;
    setEnemyHealth();
    player = game.player;
    priority = 11;

    hitbox = RectangleHitbox(
      position: Vector2(15, 5),
      size: Vector2(60, 90),
    );

    add(hitbox);
    _loadAllAnimations();
    _calculateRange();

    return super.onLoad();
  }

  void fireEnemyBullet() {

    if (isFiringEnemyBullet) {
      return;
    }

    isFiringEnemyBullet = true;

    game.zaWarudoo.fireBullet(this, const Duration(seconds: 5), setBulletType());

    //Wait for seconds
    Future.delayed(Duration(milliseconds: fireRate), () {isFiringEnemyBullet = false;});
  }

BulletType setBulletType(){
    switch (enemyType) {
        case EnemyType.trasher:
            return BulletType.trasher;
        case EnemyType.airPolluter:
            return BulletType.airPolluter;
        case EnemyType.noisePolluter:
            return BulletType.noisePolluter;
        case EnemyType.towerDestroyer:
            return BulletType.towerDestroyer;
        case EnemyType.deforester:
            return BulletType.deforester;
        default:
            return BulletType.trasher;
    }
}



  //     // Do something with the hit component
  //   }
  // }

  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }

    // performRaycast();
    fireEnemyBullet();

    super.update(dt);
  }
  
  void _loadAllAnimations() {
    // _idleAnimation = _spriteAnimation("idle", 12);
    _runAnimation = _spriteAnimation("running", 12);
    // _hitAnimation = _spriteAnimation("Hit", 5)..loop = false;

    animations = {
        // State.idle: _idleAnimation,
        State.run: _runAnimation,
        // State.hit: _hitAnimation,
    };

    // current = State.idle;
    current = State.idle;
  }


  SpriteAnimation _spriteAnimation(String state, int amount){

    String enemyName = "";

    switch (enemyType) {
      case EnemyType.towerDestroyer:
      enemyName = "Trasher";
      break;
      case EnemyType.trasher:
        // enemyName = "Trasher";
        break;
      case EnemyType.noisePolluter:
        enemyName = "Noisers";
        break;
      case EnemyType.deforester:
        enemyName = "Deforester";
        break;
      case EnemyType.airPolluter:
        enemyName = "AirPolluter";
        break;
      default:
    }

    return SpriteAnimation.fromFrameData(
      

      game.images.fromCache("Enemies/$enemyName/$state.png"), 
      SpriteAnimationData.sequenced(

        amount: amount, 
        stepTime: stepTime, 
        textureSize: textureSize,
        
        ));
  }
  
  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

   SolarBuilding? findClosestBuilding(List<SolarBuilding> solarBuildingList) {
    SolarBuilding? closest;
    double closestDistance = double.infinity;

    for (final solarBuilding in solarBuildingList) {
      final double distance = position.distanceTo(solarBuilding.position);
      if (distance < closestDistance) {
        closestDistance = distance;
        closest = solarBuilding;
      }
    }

    return closest;
  }
  
   Tree? findClosestTree(List<Tree> trees) {
    Tree? closest;
    double closestDistance = double.infinity;

    for (final solarBuilding in trees) {
      final double distance = position.distanceTo(solarBuilding.position);
      if (distance < closestDistance) {
        closestDistance = distance;
        closest = solarBuilding;
      }
    }

    return closest;
  }
  
  void _movement(dt) {


  final attackables = game.zaWarudoo.solarBuildings;

  final attackableTree = game.zaWarudoo.trees;

  final closest = game.currentLevelIndex > 0 ? findClosestTree(attackableTree) : findClosestBuilding(attackables);

      if (closest != null) {
      // targetPosition = closest.position;
      // moveTowardsTarget(dt);
      

//    MOVE TOWARDS SOLAR TOWER SCRIPT
//__________________________________________________________________________________________________
    double buildingOffset = (closest.scale.x > 0) ? closest.width : -closest.width;
    double enemyOffset = (scale.x > 0) ? width : -width;

    velocity = Vector2.zero();

    targetDirectionX = (closest.x + buildingOffset < position.x + enemyOffset) ? -1 : 1;
    targetDirectionY = (closest.y < position.y) ? -1 : 1;

    velocity = Vector2(targetDirectionX * enemyMoveSpeed, targetDirectionY * enemyMoveSpeed);

    moveDirection = lerpDouble(moveDirection, targetDirectionX, 0.1)?? 1;
    // moveDirection = targetDirectionX;

    // position += velocity * dt;
    position.add(velocity * dt);
//__________________________________________________________________________________________________
    }

//Move Towards TOwer Script
//-----------------------------------------------------------------------------------------------------------------------
// if (enemyType == EnemyType.towerDestroyers) {
//       double solarBuildingOffset = (game.zaWarudoo.solarBuilding.scale.x > 0) ? 0 : -game.zaWarudoo.solarBuilding.width;
//     double enemyOffset = (scale.x > 0) ? 0 : -width;

//     velocity = Vector2.zero();

//     targetDirectionX = (game.zaWarudoo.solarBuilding.x + solarBuildingOffset < position.x + enemyOffset) ? -1 : 1;
//     targetDirectionY = (game.zaWarudoo.solarBuilding.y - solarBuildingOffset < position.y + enemyOffset) ? -1 : 1;

//     velocity = Vector2(targetDirectionX * enemyMoveSpeed, targetDirectionY * enemyMoveSpeed);

//     moveDirection = lerpDouble(moveDirection, targetDirectionX, 0.1)?? 1;

//     position += velocity * dt;
// }
//-----------------------------------------------------------------------------------------------------------------------


//    MOVE TOWARDS PLAYER SCRIPT
//__________________________________________________________________________________________________
    // double playerOffset = (player.scale.x > 0) ? player.width : -player.width;
    // double enemyOffset = (scale.x > 0) ? width : -width;

    // velocity = Vector2.zero();

    // targetDirectionX = (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
    // targetDirectionY = (player.y < position.y) ? -1 : 1;

    // velocity = Vector2(targetDirectionX * enemyMoveSpeed, targetDirectionY * enemyMoveSpeed);

    // moveDirection = lerpDouble(moveDirection, targetDirectionX, 0.1)?? 1;
    // // moveDirection = targetDirectionX;

    // // position += velocity * dt;
    // position.add(velocity * dt);
//__________________________________________________________________________________________________


    //SCALE = -1 MEANS FLIPPED
    //SCALE = 1 MEANS NORMAL
    //-------------------------------------------------------------------------
    //Move to Player LOgic
    // velocity.x = 0;

    // double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    // double enemyOffset = (scale.x > 0) ? 0 : -width;

    // if (playerInRange()) {
    //   //Player In Range
    //   targetDirection = (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
    //   velocity.x = targetDirection * runSpeed;
    // }

    // moveDirection = lerpDouble(moveDirection, targetDirection, 0.1)?? 1;

    // position.x += velocity.x * dt;
    //-------------------------------------------------------------------------
  }


  bool playerInRange(){
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return player.x + playerOffset >= rangeNeg && player.x + playerOffset <= rangePos &&
           player.y + player.height > position.y &&
           player.y < position.y + height ;
  }
  
  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.run; //CHANGE STAET HERE AFTER ANIM EXISTS

    if ((moveDirection > 0) && scale.x < 0 || (moveDirection < 0) && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }


  }


  void gotHit(){

    game.screenShake(const Duration(milliseconds: 300));
    if(game.canPlaySound){game.playSound("enemyIsHit");}
    
    enemyHealth --;
  
    if (enemyHealth <= 0 && !isDead) {
      //Prevents more than one resource drop
      isDead = true;
    game.zaWarudoo.spawnEnemyDrop(this);
    game.enemyCount --;
          
    if (game.enemyCount <= 0) {

      game.levelCleared = true;

      game.zaWarudoo.collectDroppedResourcesPrompt();

      }
    removeFromParent();
    }

  }
  
  void setEnemyHealth() {
    switch (enemyType) {
      case EnemyType.towerDestroyer:
        enemyHealth = 3;
        break;

      case EnemyType.noisePolluter:
      enemyHealth = 3;
      break;
      default:
    }
  }
}  