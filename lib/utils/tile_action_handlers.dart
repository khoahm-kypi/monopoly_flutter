import 'package:flutter/material.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/models/chance_card_model.dart';
import 'package:monopoly_ant/providers/language_provider.dart';

class TileActionHandlers {
  static Future<void> showBuyPropertyDialog(
    BuildContext context, 
    PropertyTile property, 
    Language language,
    VoidCallback onBuy,
    VoidCallback onSkip,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.get(language, 'buy_property_title', params: {'name': property.name})),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get(language, 'buy_price', params: {'price': property.price.toString()}), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(AppStrings.get(language, 'rent_price', params: {'price': property.rent.toString()}), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text(AppStrings.get(language, 'buy_confirm')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.get(language, 'skip'), style: const TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onSkip();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: Text(AppStrings.get(language, 'buy_now')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onBuy();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showChanceCardDialog(
    BuildContext context, 
    ChanceCard card, 
    Language language,
    VoidCallback onConfirm,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.star, color: Colors.orange),
              const SizedBox(width: 8),
              Text(AppStrings.get(language, 'chance')),
            ],
          ),
          content: Text(AppStrings.get(language, 'chance_${card.id}'), style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: Text(AppStrings.get(language, 'confirm')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showUpgradePropertyDialog(
    BuildContext context, 
    PropertyTile property, 
    Language language,
    VoidCallback onUpgrade,
    VoidCallback onSkip,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.get(language, 'upgrade_title', params: {'name': property.name})),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get(language, 'current_houses', params: {'count': property.houseCount.toString()}), style: const TextStyle(fontSize: 16)),
              Text(AppStrings.get(language, 'current_rent', params: {'price': property.currentRent.toString()}), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text(AppStrings.get(language, 'upgrade_cost', params: {'price': property.upgradeCost.toString()}), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              Text(AppStrings.get(language, 'next_rent', params: {'price': property.copyWith(houseCount: property.houseCount + 1).currentRent.toString()}), style: const TextStyle(fontSize: 16, color: Colors.red)),
              const SizedBox(height: 20),
              Text(AppStrings.get(language, 'upgrade_confirm')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.get(language, 'skip'), style: const TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onSkip();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: Text(AppStrings.get(language, 'build')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onUpgrade();
              },
            ),
          ],
        );
      },
    );
  }
}
