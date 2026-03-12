import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/providers/language_provider.dart';

class PlayerPanelWidget extends StatelessWidget {
  final Player player;
  final bool isCurrentTurn;
  final List<PropertyTile> ownedProperties;
  final Language language;

  const PlayerPanelWidget({
    Key? key,
    required this.player,
    required this.isCurrentTurn,
    required this.ownedProperties,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPropertyDetail(context),
      child: Opacity(
        opacity: player.isActive ? 1.0 : 0.4,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isCurrentTurn
                ? Border.all(color: Colors.amber, width: 3)
                : Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: isCurrentTurn
                ? [const BoxShadow(color: Colors.amber, blurRadius: 10)]
                : [],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: player.tokenColor,
                child: player.inJail
                    ? const Icon(Icons.lock, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        player.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '\$${player.money}',
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                    if (ownedProperties.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: ownedProperties
                            .map((p) => Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Color(p.colorValue),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.black26, width: 1),
                                  ),
                                  child: Tooltip(
                                    message: '${p.name} (${AppStrings.get(language, 'rent_price', params: {'price': p.rent.toString()})})',
                                    child: const SizedBox.expand(),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPropertyDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(language, 'turn_of', params: {'name': player.name})),
        content: SizedBox(
          width: 400,
          child: ownedProperties.isEmpty
              ? Center(child: Text(AppStrings.get(language, 'no_actions')))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ownedProperties.length,
                  itemBuilder: (context, index) {
                    final p = ownedProperties[index];
                    return ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(p.colorValue),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${AppStrings.get(language, 'buy_price', params: {'price': p.price.toString()})} | ${AppStrings.get(language, 'rent_price', params: {'price': p.rent.toString()})}'),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(language, 'close')),
          ),
        ],
      ),
    );
  }
}
