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
        return _buildNeonDialog(
          context: dialogContext,
          title: AppStrings.get(language, 'buy_property_title', params: {'name': property.name}),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(property.colorValue).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(property.colorValue).withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(property.colorValue),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.get(language, 'buy_price', params: {'price': property.price.toString()}),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.greenAccent),
                        ),
                        Text(
                          AppStrings.get(language, 'rent_price', params: {'price': property.rent.toString()}),
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.get(language, 'buy_confirm'),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          actions: [
            _buildNeonButton(
              label: AppStrings.get(language, 'skip'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onSkip();
              },
              isOutlined: true,
            ),
            const SizedBox(width: 12),
            _buildNeonButton(
              label: AppStrings.get(language, 'buy_now'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onBuy();
              },
              color: Colors.greenAccent,
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
        return _buildNeonDialog(
          context: dialogContext,
          title: AppStrings.get(language, 'chance').toUpperCase(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars, color: Colors.amberAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                AppStrings.get(language, 'chance_${card.id}'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            _buildNeonButton(
              label: AppStrings.get(language, 'confirm'),
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
        return _buildNeonDialog(
          context: dialogContext,
          title: AppStrings.get(language, 'upgrade_title', params: {'name': property.name}),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                AppStrings.get(language, 'current_houses', params: {'count': property.houseCount.toString()}),
                Icons.home_outlined,
              ),
              _buildInfoRow(
                AppStrings.get(language, 'current_rent', params: {'price': property.currentRent.toString()}),
                Icons.attach_money,
              ),
              const Divider(color: Colors.white10, height: 24),
              _buildInfoRow(
                AppStrings.get(language, 'upgrade_cost', params: {'price': property.upgradeCost.toString()}),
                Icons.add_circle_outline,
                color: Colors.cyanAccent,
              ),
              _buildInfoRow(
                AppStrings.get(language, 'next_rent', params: {'price': property.copyWith(houseCount: property.houseCount + 1).currentRent.toString()}),
                Icons.trending_up,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.get(language, 'upgrade_confirm'),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          actions: [
            _buildNeonButton(
              label: AppStrings.get(language, 'skip'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onSkip();
              },
              isOutlined: true,
            ),
            const SizedBox(width: 12),
            _buildNeonButton(
              label: AppStrings.get(language, 'build'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onUpgrade();
              },
              color: Colors.cyanAccent,
            ),
          ],
        );
      },
    );
  }

  static Widget _buildNeonDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 40, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Colors.white10),
            ),
            content,
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String text, IconData icon, {Color color = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color.withOpacity(0.5)),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color, fontSize: 15)),
        ],
      ),
    );
  }

  static Widget _buildNeonButton({
    required String label,
    required VoidCallback onPressed,
    bool isOutlined = false,
    Color color = Colors.cyanAccent,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          boxShadow: isOutlined ? [] : [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 10),
          ],
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isOutlined ? color : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
