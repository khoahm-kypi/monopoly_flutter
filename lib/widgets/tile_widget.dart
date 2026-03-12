import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/providers/game_provider.dart';
import 'package:monopoly_ant/providers/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileWidget extends ConsumerWidget {
  final Tile tile;
  final Color? ownerColor;

  const TileWidget({Key? key, required this.tile, this.ownerColor}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.read(gameProvider);
    final language = boardState.language;

    String displayName = tile.name;
    if (tile.type == TileType.go) displayName = AppStrings.get(language, 'go');
    else if (tile.type == TileType.jail) displayName = AppStrings.get(language, 'jail');
    else if (tile.type == TileType.parking) displayName = AppStrings.get(language, 'parking');
    else if (tile.type == TileType.goToJail) displayName = AppStrings.get(language, 'go_to_jail');
    else if (tile.type == TileType.chance) displayName = AppStrings.get(language, 'chance');
    else if (tile.type == TileType.tax) {
      displayName = AppStrings.get(language, 'tax_amount', params: {'amount': '100'});
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ownerColor?.withOpacity(0.8) ?? Colors.white.withOpacity(0.2),
          width: ownerColor != null ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (ownerColor ?? Colors.cyan).withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
          if (ownerColor != null)
            BoxShadow(
              color: ownerColor!.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                    child: Text(
                      displayName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.cyan.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (tile is PropertyTile)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  '\$${(tile as PropertyTile).price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (tile is PropertyTile) {
      final prop = tile as PropertyTile;
      final color = Color(prop.colorValue);
      return Container(
        height: 6,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            prop.houseCount,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withOpacity(0.5), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
