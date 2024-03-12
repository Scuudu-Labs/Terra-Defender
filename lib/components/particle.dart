import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:terra_defender/terra_defender.dart';

class Particle extends SpriteAnimationComponent with HasGameRef<TerraDefender>, CollisionCallbacks{
  String name;
  
  Particle({this.name = "particle", position, size}) : super(position: position, size: size);

  final double stepTime = 0.08;



  @override
  FutureOr<void> onLoad() {

    priority = 12;


    if(game.canPlaySound){game.playSound("flame");}

    animation = SpriteAnimation.fromFrameData(game.images.fromCache("Enemies/Deforester/$name.png"), SpriteAnimationData.sequenced(amount: 4, stepTime: stepTime, textureSize: Vector2.all(96)));
    
    Future.delayed(const Duration(milliseconds: 700), (){removeFromParent();});

    return super.onLoad();
  }
}