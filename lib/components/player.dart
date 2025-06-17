import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:memo_adventure/components/collision_block.dart';
import 'package:memo_adventure/components/player_hitbox.dart';
import 'package:memo_adventure/components/utils.dart';
import 'package:memo_adventure/memo_adventure.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<MemoAdventure>, KeyboardHandler {
  String character;
  Player({position, this.character = 'NinjaFrog'})
    : super(
        position: position,
      ); // position is built in SpriteAnimation Component
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  final double stepTime = 0.05; // 50ms = 20fps
  final double _gravity = 10;
  final double _jumpForce = 250;
  final double _terminalVelocity = 300; //curved falling speed, but maximum at terminal velocity
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 10, 
    offsetY: 4, 
    width: 14, 
    height: 28
  );

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size:Vector2(hitbox.width, hitbox.height),
    ));
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //delta time update time of frame in time fps
    _updatePlayerState(dt);
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt); // the method calling order matters
    _checkVerticalCollisions();
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('idle', 11);
    runningAnimation = _spriteAnimation('run', 12);
    jumpingAnimation = _spriteAnimation('jump', 1);
    fallingAnimation = _spriteAnimation('fall', 1);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
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
    if (hasJumped && isOnGround){
      _playerJump(dt);
    }
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt){
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    if (velocity.x > 0 || velocity.x < 0){
      playerState = PlayerState.running;
    }
    if (velocity.y > 0 ){
      playerState = PlayerState.falling;
    }
    if (velocity.y < 0){
      playerState = PlayerState.jumping;
    }
    current = playerState;
  }

  void _checkHorizontalCollisions(){
    for (final block in collisionBlocks){
      if(!block.isPlatform){
        if(checkCollision(this, block)){
          if(velocity.x > 0){
            velocity.x = 0;
            position.x = block.x - hitbox.width - hitbox.offsetX;
            break;
          }
          if(velocity.x < 0){
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions(){
    for(final block in collisionBlocks){
      if(checkCollision(this, block)){
        if(velocity.y > 0){
          velocity.y = 0;
          position.y = block.y - hitbox.height - hitbox.offsetY;
          isOnGround = true;
          break;
        }
        else if(velocity.y < 0 && !block.isPlatform){
          velocity.y = 0;
          position.y = block.y + block.height;
        }
      }

    }
  }
  void _applyGravity(double dt){
    velocity.y += _gravity;
    // not further up then jump force and fall down any faster than terminal velocity
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity); 
    position.y += velocity.y * dt;

  }
}
