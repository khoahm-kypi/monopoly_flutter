enum ChanceEffectType {
  addMoney,
  subtractMoney,
  moveTo,
}

class ChanceCard {
  final String id;
  final String description;
  final ChanceEffectType effectType;
  final int value; // Money amount or Tile Index to move to

  const ChanceCard({
    required this.id,
    required this.description,
    required this.effectType,
    required this.value,
  });
}

class ChanceDeck {
  static final List<ChanceCard> defaultCards = [
    const ChanceCard(
      id: 'c1',
      description: 'Bank error in your favor! Collect \$50.',
      effectType: ChanceEffectType.addMoney,
      value: 50,
    ),
    const ChanceCard(
      id: 'c2',
      description: 'Traffic violation. Pay fine \$20.',
      effectType: ChanceEffectType.subtractMoney,
      value: 20,
    ),
    const ChanceCard(
      id: 'c3',
      description: 'Lottery win! Receive \$100.',
      effectType: ChanceEffectType.addMoney,
      value: 100,
    ),
    const ChanceCard(
      id: 'c4',
      description: 'Advance to GO (Collect \$200).',
      effectType: ChanceEffectType.moveTo,
      value: 0,
    ),
    const ChanceCard(
      id: 'c5',
      description: 'Lost wallet. Lose \$30.',
      effectType: ChanceEffectType.subtractMoney,
      value: 30,
    ),
    const ChanceCard(
      id: 'c6',
      description: 'Medical fees. Spend \$50.',
      effectType: ChanceEffectType.subtractMoney,
      value: 50,
    ),
  ];
}
