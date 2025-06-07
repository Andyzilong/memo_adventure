import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:memo_adventure/levels/level.dart';

class MemoAdventure extends FlameGame {

  late final CameraComponent cam;
  
  final world = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
      world: world, width: 640, height: 360
    );
    
    addAll([cam, world]);
    return super.onLoad();
  }

}