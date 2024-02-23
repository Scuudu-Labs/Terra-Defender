import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/terra_defender.dart';

enum State{idle, run, hit}

class Enemy extends SpriteAnimationGroupComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  // Chicken({position, size}) : super(position: position, size: size);

  //Shorthand
   Enemy({super.position, super.size, this.offNeg = 0, this.offPos = 0,});

  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomped = false;
   final double offNeg;
   final double offPos;

   
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const runSpeed = 80;
  final double _bounceHeight = 300;
  final textureSize = Vector2(96, 96);

  double rangeNeg = 0;
  double rangePos = 0;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  // late final SpriteAnimation _hitAnimation;

   @override
  FutureOr<void> onLoad() {
    debugMode = true;
    player = game.player;

    add(RectangleHitbox(
      position: Vector2(15, 5),
      size: Vector2(60, 90),
    ));
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }

    super.update(dt);
  }
  
  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation("idle", 12);
    _runAnimation = _spriteAnimation("running", 12);
    // _hitAnimation = _spriteAnimation("Hit", 5)..loop = false;

    animations = {
        State.idle: _idleAnimation,
        State.run: _runAnimation,
        // State.hit: _hitAnimation,
    };

    // current = State.idle;
    current = State.idle;
  }


  SpriteAnimation _spriteAnimation(String state, int amount){
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemies/Trasher/$state.png"), 
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
  
  void _movement(dt) {
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double enemyOffset = (scale.x > 0) ? 0 : -width;

    if (playerInRange()) {
      //Player In Range
      targetDirection = (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
      velocity.x = targetDirection * runSpeed;
    }

    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1)?? 1;

    position.x += velocity.x * dt;
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

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y ) {
      if (game.playSounds) {
        // FlameAudio.play("Bounce.wav", volume: game.soundVolume);
      }
      gotStomped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;

      // await animationTicker?.completed;
      removeFromParent();
    }
    else{
      player.colliderWithEnemy();
    }
  }

  void gotHit(){
    game.logger.d("Hit Enemy");
    removeFromParent();
  }
}  