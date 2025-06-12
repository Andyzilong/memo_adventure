import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:memo_adventure/levels/level.dart';

class MemoAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFf211F30);
  late final CameraComponent cam;
  
  final world = Level();

  @override
  FutureOr<void> onLoad() async{
    // All images are loaded beforehand into cache
    await images.loadAllImages();
    
    cam = CameraComponent.withFixedResolution(
      world: world, width: 640, height: 360
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    
    addAll([cam, world]);


    return super.onLoad();
  }

}