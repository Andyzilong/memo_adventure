import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:memo_adventure/memo_adventure.dart';

enum PlayerState {
  idle, 
  running
}

class Player extends SpriteAnimationGroupComponent with HasGameReference<MemoAdventure>{
 
  String character;
  Player({position, required this.character}): super(position: position); // position is built in SpriteAnimation Component
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // 50ms = 20fps

  @override
  FutureOr<void> onLoad()async{
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations(){
    idleAnimation = _spriteAnimation('idle', 11);
    runningAnimation = _spriteAnimation('run', 12);
    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    // Set current animation
    current = PlayerState.idle;
  } 

  SpriteAnimation _spriteAnimation(String state, int framePics) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('MainCharacters/$character/$state.png'), 
      SpriteAnimationData.sequenced(
        amount: framePics, //idle animation sequence from image
        stepTime: stepTime, 
        textureSize: Vector2.all(32), // =Vector2(32,32);
      ),
    );

  }

}