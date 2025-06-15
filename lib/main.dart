import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memo_adventure/memo_adventure.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();


  MemoAdventure game = MemoAdventure();
  runApp(
    GameWidget(game: kDebugMode ? MemoAdventure() : game),
    
    );
}