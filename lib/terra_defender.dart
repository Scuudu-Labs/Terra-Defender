import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:terra_defender/components/levels.dart';
import 'package:terra_defender/components/player.dart';
import 'package:terra_defender/components/shoot_button.dart';
import 'package:flame_noise/flame_noise.dart';

class TerraDefender extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks 
  {

  Logger logger = Logger();
  Player player = Player(position: Vector2(500, 400));

  late JoystickComponent joystick;
  late SpriteComponent shootButton = ShootButton();
  late CameraComponent cam;
  late Levels zaWarudoo;

  // bool showControls = true;
  bool levelCleared = false;
  bool canPlaySound = true;
  bool canUseJoystick = false; 

  // double soundVolume = 1.0;
  double soundVolume = 0.2;

  late int trashCount = 0;
  late int enemyCount = 0;
  late int towerCount = 0;

  late Vector2 originalPosition;
  double shakeTimer = 0.0;
  double shakeIntensity = 5.0;

  late final _cameraShake = MoveEffect.by(Vector2(3, 3), InfiniteEffectController(ZigzagEffectController(period: 0.2)));

  Random random = Random();

  List<String> levelNames = ["Level_01", "Level_02"];
  int currentLevelIndex = 0;

  //Sets the background color to match
  // @override
  // Color backgroundColor() => const Color.fromARGB(255, 22, 36, 231); GameBackground.png



  bool get showControls {
  // If it's web, return false
  if (kIsWeb) {
    return false;
  } else {
    // If it's Android or iOS, return true, otherwise false

    bool isMobileDevice = Platform.isAndroid || Platform.isIOS;
    // logger.d("is mobile Device: $isMobileDevice");
    return isMobileDevice;
  }
}

  @override
  FutureOr<void> onLoad() async {
    //Load all images into the cache
    await images.loadAllImages();

    // if (canPlaySound) {playSound("ThemeMusic3");}

    FlameAudio.bgm.play("ThemeMusic3.5.wav");

     _loadLevel();

     // Assuming the image is already loaded into the cache
    final backgroundImage = images.fromCache('Background/GameBackground.png');
    
    // Create a SpriteComponent using the cached image
    final background = SpriteComponent()
      ..sprite = Sprite(backgroundImage)
      ..size = size; // Set the size of the background to match the game size
    
    // Add the background component to the game
    add(background);

    

    // Future.delayed(const Duration(seconds: 5), (){_cameraShake.pause();});

    


    return super.onLoad();
  }

  @override
  void update(double dt) {

    if (showControls && canUseJoystick) {

      updateJoystick();
      
    }

    super.update(dt);
  }

  void addMobileControls() {
    joystick = JoystickComponent(
      size: 32,

      priority: 10,
      knob: SpriteComponent(
        size: Vector2.all(150),
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        size: Vector2.all(200),
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(left: 50, bottom: 50),
      // anchor: Anchor.center
    )..priority = 10;

    // add(joystick);
    cam.viewport.add(joystick);
    cam.viewport.add(shootButton);

    Future.delayed(const Duration(milliseconds: 800), (){canUseJoystick = true;});
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

  void playSound(String soundName){
    
    if(canPlaySound){FlameAudio.play("$soundName.wav", volume: soundVolume);}

  }

  void toggleCameraShake(bool camShakeOn){ 
    if (camShakeOn) {
      _cameraShake.resume();
    }
    else{
      _cameraShake.pause();
    }
}

void screenShake(Duration duration){
  toggleCameraShake(true);

    Future.delayed(duration, (){toggleCameraShake(false);});
}
  
  int randomNumberInRange(int min, int max) {
  return min + random.nextInt(max - min);
}

// Generate a random double between min (inclusive) and max (exclusive)
double randomDoubleInRange(double min, double max) {
  return min + random.nextDouble() * (max - min);
}

  void loadNextLevel(){
    //Deleted the level
    removeWhere((component) => component is Levels);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    }
    else{
      //No more Levels
      currentLevelIndex = 0;

      overlays.add('InDevelopment');
      
      _loadLevel();
    }
  }

  void _loadLevel() async {
    Future.delayed(const Duration(seconds: 1), (){
      
    // Levels zaWorld = Levels(levelName: levelNames[currentLevelIndex], player: player);
    zaWarudoo = Levels(levelName: levelNames[currentLevelIndex], player: player);

    //Camera that sees the worls here
    cam = CameraComponent.withFixedResolution(
        world: zaWarudoo, width: 1280, height: 704);

    //Code for anchoring the cam to the left
    cam.viewfinder.anchor = Anchor.topLeft;

    cam.viewfinder.add(_cameraShake);

    _cameraShake.pause();

    //Adding the camera and the world
    addAll([
      cam,
      zaWarudoo,
    ]);

    if (showControls) {
      addMobileControls();

      // debugMode = true;
    }
    });
  }

  void loadLevelWithIndex(int levelToLoad){

    currentLevelIndex = levelToLoad;

    Future.delayed(const Duration(seconds: 1), (){
      
    // Levels zaWorld = Levels(levelName: levelNames[currentLevelIndex], player: player);
    zaWarudoo = Levels(levelName: levelNames[currentLevelIndex], player: player);

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
    });
  }

  void restartGame(){
   
    remove(zaWarudoo);
    resumeGame();
    currentLevelIndex = 0;
    _loadLevel();
                        
    Future.delayed(const Duration(milliseconds: 1100), (){

    overlays.remove('GameOver');

    
    // logger.d("Pressed, Play Again");

    });



  }

  void showGameOverScreen(){

    overlays.add('GameOver');
    
    pauseGame();
  }

  void pauseGame(){
    paused = true;
  }

  void resumeGame(){
    paused = false;
  }

  void startGame(){
    playSound("onPickup");
    overlays.remove('MainMenu');
    zaWarudoo.spawnText("Pick Up the Trash");
  }

  void reset(){
    
  }


}
