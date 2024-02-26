import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/collision_block.dart';
import 'package:terra_defender/components/custom_hitbox.dart';
import 'package:terra_defender/components/trash.dart';
import 'package:terra_defender/components/utils.dart';
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
  // double moveSpeed = 500;

  Vector2 velocity = Vector2.zero();

  List<CollissionBlock> collissionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(offsetX: 15, offsetY: 5, width: 60, height: 90,);
  RectangleHitbox pHitBox = RectangleHitbox(position: Vector2(15, 5), size: Vector2(60, 90));




  @override
  FutureOr<void> onLoad() async {
    // startPos = position;
    debugMode = true;
    size = Vector2.all(96);
    priority = 11;

    _loadAllAnimations();

  
    add(pHitBox);


    return super.onLoad();
  }

  @override
  void update(double dt) {
    
    _updatePlayerState();
    _updatePlayerMovement(dt);
    // _checkHorizontalCollissions();
    // _checkVerticalCollissions();


    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      game.logger.d("Is Hit");
    }

    if (other is Trash) {
      other.collidedWithPlayer();
    }

     if (other is ScreenHitbox) {
      // If there is a collision with the ScreenHitbox, adjust the player's position
      // This example assumes a simple case where the player is a rectangle
      game.logger.d("Screen Hit");
      final srHitbox = pHitBox;
      if (position.x < 0) {
        position.x = 0; // Left collision
      game.logger.d("Left Hit");

      } else if (position.x + srHitbox.size.x > size.x) {
        position.x = size.x - srHitbox.size.x; // Right collision
      game.logger.d("Right Hit");

      }
      if (position.y < 0) {
        position.y = 0; // Top collision
      game.logger.d("Top Hit");

      } else if (position.y + srHitbox.size.y > size.y) {
        position.y = size.y - srHitbox.size.y; // Bottom collision
      game.logger.d("Bottom Hit");

      }
      // Reset velocity if you want the player to stop moving upon collision
      velocity.setZero();
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

    void _checkHorizontalCollissions() {
    for (final block in collissionBlocks) {
      //Handle collission
      //If not a platform, check horizontal collissions
      if (!block.isPlatform) {
        if (checkCollission(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX + 5;
            break;
          }
        }
      }
    }
  }

   void _checkVerticalCollissions() {
    for (final block in collissionBlocks) {
      if (block.isPlatform) {
        //Handle platform collission
        if (checkCollission(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            break;
          }
        }
      } else {
        if (checkCollission(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }

  void colliderWithEnemy() {}




}