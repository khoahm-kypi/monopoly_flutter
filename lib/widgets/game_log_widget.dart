import 'package:flutter/material.dart';
import 'package:monopoly_ant/providers/language_provider.dart';

class GameLogWidget extends StatelessWidget {
  final List<String> logs;
  final String currentPlayerName;
  final Language language;
  final VoidCallback onShowAll;

  const GameLogWidget({
    Key? key,
    required this.logs,
    required this.currentPlayerName,
    required this.language,
    required this.onShowAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentLogs = logs
        .where((log) => !log.startsWith('[TURN]'))
        .toList()
        .reversed
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get(language, 'game_log'),
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    AppStrings.get(language, 'turn_of', params: {'name': currentPlayerName}),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.history, color: Colors.white, size: 18),
                onPressed: onShowAll,
                tooltip: AppStrings.get(language, 'game_history'),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 10),
          ...recentLogs.map((log) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  log,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          if (logs.isEmpty)
             Text(
              AppStrings.get(language, 'no_actions'),
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
        ],
      ),
    );
  }
}
