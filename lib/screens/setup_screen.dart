import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/providers/game_provider.dart';
import 'package:monopoly_ant/screens/game_screen.dart';
import 'package:monopoly_ant/models/board_state.dart';
import 'package:monopoly_ant/providers/language_provider.dart';
import 'package:hive/hive.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  int _playerCount = 2;
  bool _hasSavedGame = false;
  final List<TextEditingController> _nameControllers = [];
  final List<Color> _availableColors = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow, 
    Colors.purple, Colors.orange, Colors.pink, Colors.cyan
  ];
  final List<Color> _selectedColors = [];
  final List<bool> _isBotFlags = [];
  int _initialMoney = 1500;
  int _goSalary = 200;
  Language _selectedLanguage = Language.en;

  @override
  void initState() {
    super.initState();
    _initPlayers();
    _checkSavedGame();
  }

  void _checkSavedGame() {
    final box = Hive.box<BoardState>('game_save');
    setState(() {
      _hasSavedGame = box.containsKey('current_match');
    });
  }

  void _initPlayers() {
    _nameControllers.clear();
    _selectedColors.clear();
    _isBotFlags.clear();
    for (int i = 0; i < 4; i++) {
      _nameControllers.add(TextEditingController(text: 'Player ${i + 1}'));
      _selectedColors.add(_availableColors[i]);
      _isBotFlags.add(false);
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final uuid = const Uuid();
    final List<Player> players = [];
    
    for (int i = 0; i < _playerCount; i++) {
      players.add(Player(
        id: uuid.v4(),
        name: _nameControllers[i].text.trim().isEmpty 
            ? 'Player ${i + 1}' 
            : _nameControllers[i].text.trim(),
        tokenColorValue: _selectedColors[i].value,
        isBot: _isBotFlags[i],
        money: _initialMoney,
      ));
    }

    ref.read(gameProvider.notifier).setupGame(
      players, 
      initialMoney: _initialMoney,
      goSalary: _goSalary,
      language: _selectedLanguage,
    );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'MONOTRAVEL',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 600,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.get(_selectedLanguage, 'num_players'), style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 20),
                        DropdownButton<int>(
                          value: _playerCount,
                          items: [2, 3, 4].map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(AppStrings.get(_selectedLanguage, 'players_count', params: {'count': e.toString()})),
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() { _playerCount = val; });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.get(_selectedLanguage, 'language_label'), style: const TextStyle(fontSize: 16)),
                        ChoiceChip(
                          label: const Text('English'),
                          selected: _selectedLanguage == Language.en,
                          onSelected: (val) { if (val) setState(() { _selectedLanguage = Language.en; }); },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Tiếng Việt'),
                          selected: _selectedLanguage == Language.vi,
                          onSelected: (val) { if (val) setState(() { _selectedLanguage = Language.vi; }); },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(AppStrings.get(_selectedLanguage, 'initial_money'), style: const TextStyle(fontSize: 14)),
                            DropdownButton<int>(
                              value: _initialMoney,
                              items: [1000, 1500, 2000].map((e) => DropdownMenuItem(
                                value: e,
                                child: Text('\$$e'),
                               )).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() { _initialMoney = val; });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(AppStrings.get(_selectedLanguage, 'go_salary'), style: const TextStyle(fontSize: 14)),
                            DropdownButton<int>(
                              value: _goSalary,
                              items: [100, 150, 200, 250, 300].map((e) => DropdownMenuItem(
                                value: e,
                                child: Text('\$$e'),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() { _goSalary = val; });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    ...List.generate(_playerCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _selectedColors[index],
                              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _nameControllers[index],
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: AppStrings.get(_selectedLanguage, 'player_name_label'),
                                  border: const OutlineInputBorder(),
                                  counterText: '',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppStrings.get(_selectedLanguage, 'bot_toggle'), style: const TextStyle(fontSize: 12)),
                                Switch(
                                  value: _isBotFlags[index],
                                  onChanged: (val) {
                                    setState(() {
                                      _isBotFlags[index] = val;
                                      if (val && _nameControllers[index].text == 'Player ${index + 1}') {
                                        _nameControllers[index].text = 'Bot ${index + 1}';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_hasSavedGame) ...[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              );
                            },
                            child: Text(AppStrings.get(_selectedLanguage, 'resume_game')),
                          ),
                          const SizedBox(width: 20),
                        ],
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _startGame,
                          child: Text(AppStrings.get(_selectedLanguage, 'start_game')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
