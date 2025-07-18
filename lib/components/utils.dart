bool checkCollision(player, block){
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerHeight = hitbox.height;
  final playerWidth = hitbox.width;

  final blockX = block.x;
  final blockY = block.y;
  final blockHeight = block.height;
  final blockWidth = block.width;
  
  //for flipped animation sequence
  final fixedX = player.scale.x < 0 
    ? playerX - (hitbox.offsetX * 2) - playerWidth 
    : playerX;
  //for platform
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (
    fixedY < blockY + blockHeight &&
    playerY + playerHeight > blockY &&
    fixedX < blockX +blockWidth &&
    fixedX + playerWidth > blockX
  );
}