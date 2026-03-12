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
      backgroundColor: const Color(0xFF030712),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Colors.indigo.withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MONOPOLY ANT',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(color: Colors.cyan.withOpacity(0.8), blurRadius: 15),
                      Shadow(color: Colors.indigo.withOpacity(0.8), blurRadius: 30),
                    ],
                  ),
                ),
                Text(
                  'BATTLE FOR THE COLONY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan.withOpacity(0.7),
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: 650,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsSection(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Divider(color: Colors.white10),
                      ),
                      _buildPlayersSection(),
                      const SizedBox(height: 40),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildGlassField(
            label: AppStrings.get(_selectedLanguage, 'num_players'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _playerCount,
                dropdownColor: const Color(0xFF1F2937),
                style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                items: [2, 3, 4].map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(AppStrings.get(_selectedLanguage, 'players_count', params: {'count': e.toString()})),
                )).toList(),
                onChanged: (val) {
                  if (val != null) setState(() { _playerCount = val; });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGlassField(
            label: AppStrings.get(_selectedLanguage, 'language_label'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLangChip('EN', Language.en),
                _buildLangChip('VI', Language.vi),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLangChip(String label, Language lang) {
    bool isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () => setState(() { _selectedLanguage = lang; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.white10,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.cyanAccent : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersSection() {
    return Column(
      children: List.generate(_playerCount, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selectedColors[index],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: _selectedColors[index].withOpacity(0.4), blurRadius: 8),
                  ],
                ),
                child: Center(
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _nameControllers[index],
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: AppStrings.get(_selectedLanguage, 'player_name_label'),
                    labelStyle: const TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
              _buildBotToggle(index),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBotToggle(int index) {
    return Column(
      children: [
        Text(AppStrings.get(_selectedLanguage, 'bot_toggle'), style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Switch(
          value: _isBotFlags[index],
          activeColor: Colors.cyanAccent,
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_hasSavedGame) ...[
          _buildNeonButton(
            label: AppStrings.get(_selectedLanguage, 'resume_game'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GameScreen()),
              );
            },
            isOutlined: true,
          ),
          const SizedBox(width: 24),
        ],
        _buildNeonButton(
          label: AppStrings.get(_selectedLanguage, 'start_game'),
          onPressed: _startGame,
          isOutlined: false,
        ),
      ],
    );
  }

  Widget _buildGlassField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildNeonButton({required String label, required VoidCallback onPressed, bool isOutlined = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : Colors.cyanAccent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: isOutlined ? [] : [
            BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isOutlined ? Colors.cyanAccent : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
