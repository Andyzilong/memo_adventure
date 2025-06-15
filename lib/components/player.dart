import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:memo_adventure/memo_adventure.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<MemoAdventure>, KeyboardHandler {
  String character;
  Player({position, this.character = 'NinjaFrog'})
    : super(
        position: position,
      ); // position is built in SpriteAnimation Component
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // 50ms = 20fps

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //deltatime update time of frame in time fps
    _updatePlayerState(dt);
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('idle', 11);
    runningAnimation = _spriteAnimation('run', 12);
    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
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

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    playerState = velocity.x > 0 || velocity.x < 0
        ? PlayerState.running
        : PlayerState.idle;

    current = playerState;
  }
}
