import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/widgets/player_token_widget.dart';
import 'package:monopoly_ant/widgets/tile_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<Tile> tiles;
  final List<Player> players;
  final Widget centerWidget;
  
  const BoardWidget({
    Key? key, 
    required this.tiles, 
    required this.players,
    required this.centerWidget,
  }) : super(key: key);

  static Offset getTilePosition(int index, double tileSize) {
    if (index <= 7) {
      return Offset((7 - index) * tileSize, 7 * tileSize);
    } else if (index <= 14) {
      return Offset(0, (7 - (index - 7)) * tileSize);
    } else if (index <= 21) {
      return Offset((index - 14) * tileSize, 0);
    } else {
      return Offset(7 * tileSize, (index - 21) * tileSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boardSize = constraints.biggest.shortestSide;
        final double tileSize = boardSize / 8;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E21),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          width: boardSize,
          height: boardSize,
          child: Stack(
            children: [
              // Bottom Layer: Tiles
              ...List.generate(tiles.length, (index) {
                final tile = tiles[index];
                final pos = getTilePosition(index, tileSize);
                
                Color? ownerColor;
                if (tile is PropertyTile && tile.ownerId != null) {
                  final owner = players.firstWhere(
                    (p) => p.id == tile.ownerId,
                    orElse: () => players.first, // Should not happen in stable state
                  );
                  ownerColor = owner.tokenColor;
                }

                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  width: tileSize,
                  height: tileSize,
                  child: TileWidget(
                    tile: tile,
                    ownerColor: ownerColor,
                  ),
                );
              }),

              // Center Widget Layer (Dice)
              Positioned(
                left: tileSize,
                top: tileSize,
                width: boardSize - 2 * tileSize,
                height: boardSize - 2 * tileSize,
                child: Center(child: centerWidget),
              ),

              // Top Layer: Player Tokens
              ...List.generate(players.length, (index) {
                final player = players[index];
                if (!player.isActive) return const SizedBox.shrink();
                final pos = getTilePosition(player.position, tileSize);
                return PlayerTokenWidget(
                  player: player,
                  targetPosition: pos,
                  tileSize: tileSize,
                  playerIndex: index,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
