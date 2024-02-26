import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:terra_defender/components/Text_display.dart';
import 'package:terra_defender/components/bullet.dart';
import 'package:terra_defender/components/levels.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/shoot_button.dart';

class TerraDefender extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  Logger logger = Logger();
  Player player = Player(position: Vector2(500, 400));
  Bullet bullet = Bullet(timeBeforeDestroy: const Duration(seconds: 3));

  late JoystickComponent joystick;
  late SpriteComponent shootButton = ShootButton();
  late CameraComponent cam;
  late Levels zaWarudoo;

  bool playSounds = false;
  bool showControls = true;

  double soundVolume = 1.0;

  late int trashCount = 0;

  //Sets the background color to match
  @override
  Color backgroundColor() => const Color.fromARGB(255, 22, 36, 231);

  @override
  FutureOr<void> onLoad() async {
    //Load all images into the cache
    await images.loadAllImages();

    // Levels zaWorld = Levels(levelName: levelNames[currentLevelIndex], player: player);
    zaWarudoo = Levels(levelName: "Level_01", player: player);

    //Camera that sees the worls here
    cam = CameraComponent.withFixedResolution(
        world: zaWarudoo, width: 1280, height: 704);

    //Code for anchoring the cam to the left
    cam.viewfinder.anchor = Anchor.topLeft;

    //Adding the camera and the world
    addAll([
      cam,
      zaWarudoo,
    ]);

    if (showControls) {
      addMobileControls();

      // debugMode = true;
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {

    if (showControls) {
      updateJoystick();
    }
    
    super.update(dt);
  }

  void addMobileControls() {
    joystick = JoystickComponent(
      size: 32,

      priority: 10,
      knob: SpriteComponent(
        size: Vector2.all(96),
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        size: Vector2.all(106),
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      // anchor: Anchor.center
    )..priority = 10;

    // add(joystick);
    cam.viewport.add(joystick);
    cam.viewport.add(shootButton);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.upLeft:
        player.verticalMovement = -1;
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.up:
        player.verticalMovement = -1;
        break;

      case JoystickDirection.downLeft:
        player.verticalMovement = 1;
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.down:
        player.verticalMovement = 1;
        break;

      case JoystickDirection.right:
        player.horizontalMovement = 1;
        break;

      case JoystickDirection.upRight:
        player.verticalMovement = -1;
        player.horizontalMovement = 1;
        break;

      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        player.verticalMovement = 1;
        break;

      default:
        player.horizontalMovement = 0;
        player.verticalMovement = 0;
        break;
    }
  }
}
