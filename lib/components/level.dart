import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:memo_adventure/components/collision_block.dart';
import 'package:memo_adventure/components/player.dart';

class Level extends World {
  //late dart trust your initialization before using
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async{
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    //access the all of the spawnlayer objects
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    
    if (spawnPointsLayer!=null){
      for (final spawnPoint in spawnPointsLayer.objects){
        switch (spawnPoint.class_){
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null){
      for (final collision in collisionsLayer.objects){
        switch (collision.class_){
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.height, collision.width),
              isPlatform: true,
            );
            break;
        }
      }
    }

    return super.onLoad();
  }
}