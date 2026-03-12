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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCurrentTurn 
                ? Colors.white.withOpacity(0.15) 
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrentTurn
                  ? player.tokenColor.withOpacity(0.8)
                  : Colors.white.withOpacity(0.1),
              width: isCurrentTurn ? 2 : 1,
            ),
            boxShadow: isCurrentTurn
                ? [
                    BoxShadow(
                      color: player.tokenColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          player.tokenColor.withOpacity(0.8),
                          player.tokenColor.withOpacity(0.4),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: player.tokenColor.withOpacity(0.4),
                          blurRadius: 8,
                        )
                      ],
                    ),
                  ),
                  if (player.inJail)
                    const Icon(Icons.lock, color: Colors.white, size: 20)
                  else
                    Text(
                      player.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      player.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${player.money}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(color: Colors.green, blurRadius: 4),
                        ],
                      ),
                    ),
                    if (ownedProperties.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: ownedProperties
                            .map((p) => Container(
                                  width: 14,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color(p.colorValue),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(p.colorValue).withOpacity(0.5),
                                        blurRadius: 2,
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              if (isCurrentTurn)
                const Icon(Icons.play_arrow, color: Colors.amber, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showPropertyDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: player.tokenColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: player.tokenColor.withOpacity(0.5), blurRadius: 10),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        player.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.get(language, 'assets_of', params: {'name': player.name}).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '\$${player.money}',
                          style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: Colors.white10),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ownedProperties.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            AppStrings.get(language, 'no_actions'),
                            style: const TextStyle(color: Colors.white38),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ownedProperties.length,
                        itemBuilder: (context, index) {
                          final p = ownedProperties[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 12,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(p.colorValue),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(color: Color(p.colorValue).withOpacity(0.4), blurRadius: 4),
                                  ],
                                ),
                              ),
                              title: Text(
                                p.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${AppStrings.get(language, 'buy_price', params: {'price': p.price.toString()})} | ${AppStrings.get(language, 'rent_price', params: {'price': p.rent.toString()})}',
                                style: const TextStyle(color: Colors.white54, fontSize: 11),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  p.houseCount,
                                  (i) => const Icon(Icons.home, color: Colors.amberAccent, size: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
