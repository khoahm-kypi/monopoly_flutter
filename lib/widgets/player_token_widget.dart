import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/player_model.dart';

class PlayerTokenWidget extends StatelessWidget {
  final Player player;
  final Offset targetPosition;
  final double tileSize;
  final int playerIndex; // Used for slight offsets if multiple players on same tile

  const PlayerTokenWidget({
    Key? key,
    required this.player,
    required this.targetPosition,
    required this.tileSize,
    required this.playerIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!player.isActive) return const SizedBox.shrink();

    // Offset slightly based on player index to avoid total overlap
    final offsetDx = targetPosition.dx + (tileSize / 2) - 15 + (playerIndex % 2 == 0 ? -8 : 8);
    final offsetDy = targetPosition.dy + (tileSize / 2) - 15 + (playerIndex < 2 ? -8 : 8);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
      left: offsetDx,
      top: offsetDy,
      width: 30,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: player.tokenColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))],
        ),
        child: Center(
          child: Text(
            player.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
