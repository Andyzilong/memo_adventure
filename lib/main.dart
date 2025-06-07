import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memo_adventure/memo_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();


  MemoAdventure game = MemoAdventure();
  runApp(
    GameWidget(game: kDebugMode ? MemoAdventure() : game),
    
    );
}