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
      decoration: BoxDecoration(
        color: Colors.white,
        border: ownerColor != null 
          ? Border.all(color: ownerColor!, width: 3) 
          : Border.all(color: Colors.black54, width: 0.5),
        boxShadow: ownerColor != null 
          ? [BoxShadow(color: ownerColor!.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)] 
          : null,
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          if (tile is PropertyTile)
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '\$${(tile as PropertyTile).price}',
                  style: const TextStyle(fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (tile is PropertyTile) {
      final prop = tile as PropertyTile;
      return Container(
        height: 10,
        width: double.infinity,
        color: prop.colorGroup,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prop.houseCount > 0)
              ...List.generate(
                prop.houseCount,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Icon(Icons.home, color: Colors.white, size: 8),
                ),
              )
            else if (ownerColor != null)
              const Icon(Icons.check_circle, color: Colors.white, size: 8),
          ],
        ),
      );
    }
    return const SizedBox(height: 8);
  }
}
