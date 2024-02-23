import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/terra_defender.dart';

enum PlayerState{idle, shooting, running}

class Player extends SpriteAnimationGroupComponent with HasGameRef<TerraDefender> , KeyboardHandler, CollisionCallbacks{

  Player({position, this.character = "John"}) : super(position: position);

  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation shootingAnimation;
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;
  final textureSize = Vector2(1250, 1500);

  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 100;

  Vector2 velocity = Vector2.zero();

  // late Vector2 startPos;




  @override
  FutureOr<void> onLoad() async {
    // startPos = position;
    debugMode = true;
    size = Vector2.all(96);

    _loadAllAnimations();

    add(RectangleHitbox(
      position: Vector2(15, 5),
      size: Vector2(60, 90),

    ));


    return super.onLoad();
  }

  @override
  void update(double dt) {
    
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      game.logger.d("Is Hit");
    }
    super.onCollision(intersectionPoints, other);
  }

 @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
      horizontalMovement = 0;
      verticalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown);





    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;
    verticalMovement += isUpKeyPressed ? -1 : 0;
    verticalMovement += isDownKeyPressed ? 1 : 0;


    return super.onKeyEvent(event, keysPressed);
  }


  //Loading and setting the animations using the scalable function
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 4);

    runningAnimation = _spriteAnimation("Run", 12);

    shootingAnimation = _spriteAnimation("Run", 1);

    // List of all animations paired with the player enum state
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.shooting: shootingAnimation,
      PlayerState.running: runningAnimation,
    };

    //Set current animation
    current = PlayerState.running;
  }

//Scalable function for animation
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache("Characters/$character/$state.png"),
        SpriteAnimationData.sequenced(
            amount: amount, 
            stepTime: stepTime, 
            textureSize: textureSize
            )
          );
  }

    
  void _updatePlayerMovement(double dt) {
  
    velocity.x = horizontalMovement * moveSpeed;
    
    position.x += velocity.x * dt;
  
    velocity.y = verticalMovement * moveSpeed;
    
    position.y += velocity.y * dt;
  
  }

   void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }


    //Check if moving set to running
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }

    //Check if falling set to falling
    if (velocity.y > 0) {
      playerState = PlayerState.running;
    }

    //Check if jumping set to jumping
    if (velocity.y < 0) {
      playerState = PlayerState.running;
    }

    current = playerState;
  }

  void colliderWithEnemy() {}




}