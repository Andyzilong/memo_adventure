import 'dart:async';

import 'package:flame/components.dart';
import 'package:memo_adventure/memo_adventure.dart';

enum PlayerState {
  idle, 
  running
}

class Player extends SpriteAnimationGroupComponent with HasGameReference<MemoAdventure>{
  late final SpriteAnimation idleAnimation;
  final double stepTime = 0.05; // 50ms = 20fps

  @override
  FutureOr<void> onLoad()async{
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations(){
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('MainCharacters/NinjaFrog/idle.png'), 
      SpriteAnimationData.sequenced(
        amount: 11, //idle animation sequence from image
        stepTime: stepTime, 
        textureSize: Vector2.all(32), // =Vector2(32,32);
      ),
    );

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation
    };

    // Set current animation
    current = PlayerState.idle;

  } 

}