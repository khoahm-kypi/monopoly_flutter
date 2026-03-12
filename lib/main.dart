import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monopoly_ant/screens/setup_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monopoly_ant/models/player_model.dart';
import 'package:monopoly_ant/models/tile_model.dart';
import 'package:monopoly_ant/models/board_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(TileTypeAdapter());
  Hive.registerAdapter(PropertyTileAdapter());
  Hive.registerAdapter(ActionTileAdapter());
  Hive.registerAdapter(BoardStateAdapter());
  
  await Hive.openBox<BoardState>('game_save');
  // Force landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monopoly Ant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SetupScreen(),
    );
  }
}
