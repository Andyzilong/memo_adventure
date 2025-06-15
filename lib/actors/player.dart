import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:memo_adventure/memo_adventure.dart';

enum PlayerState {idle, running}

enum PlayerDirection {left, right, none}

class Player extends SpriteAnimationGroupComponent with HasGameReference<MemoAdventure>, KeyboardHandler{
 
  String character;
  Player({position, this.character = 'NinjaFrog'}): super(position: position); // position is built in SpriteAnimation Component
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // 50ms = 20fps

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad(){
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt){  //deltatime update time of frame in time fps
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed){
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA)|| 
      keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD)|| 
      keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if(isLeftKeyPressed && isRightKeyPressed){
      playerDirection = PlayerDirection.none;
    }
    else if (isRightKeyPressed){
      playerDirection = PlayerDirection.right;
    }
    else if (isLeftKeyPressed){
      playerDirection = PlayerDirection.left;
    }
    else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);

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

  void _updatePlayerMovement(double dt){
    double directionX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        directionX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        directionX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    
    }
    velocity = Vector2(directionX, 0.0);
    position += velocity * dt;
  }

}