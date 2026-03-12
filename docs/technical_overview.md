# Technical Overview - Monopoly Ant

## 1. Tech Stack
*   **Framework:** Flutter (Dart)
*   **State Management:** `flutter_riverpod` (using Notifiers)
*   **Local Storage:** `hive` & `hive_flutter` (for persistence)
*   **Animations:** `flutter_animate`
*   **Models:** `uuid` for unique identifiers

## 2. Core Modules

### 2.1. State management (`/lib/providers/`)
*   **`gameProvider` (`GameNotifier`)**: Manages the core game state, including player movement, purchasing properties, debt settlement, and turn ending.
*   **`languageProvider`**: Manages app localization (English/Vietnamese).

### 2.2. Models (`/lib/models/`)
*   **`BoardState`**: Current game state (players, tiles, logs, configuration).
*   **`Player`**: Player data (money, position, active status, color).
*   **`Tile`**:
    *   `PropertyTile`: Purchases, rent multipliers, and construction levels.
    *   `ActionTile`: Special tiles like GO, Jail, Chance, and Tax.
*   **`ChanceCard`**: Individual chance cards with specific effects (AddMoney, MoveTo, etc.).

### 2.3. Logic & Utilities (`/lib/core/` & `/lib/utils/`)
*   **`BoardGenerator`**: Dynamically generates the board array based on size.
*   **`TileActionHandlers`**: Static methods to trigger UI dialogs for property and chance actions.

### 2.4. Widgets (`/lib/widgets/`)
*   **`BoardWidget`**: Main visual container for the tiles and tokens.
*   **`TileWidget`**: Individual square on the board with localized names and owner indicators.
*   **`PlayerPanelWidget`**: Sidebar displays for player money and property summaries.
*   **`GameLogWidget`**: Turn-based console to output game events.

## 3. Localization Strategy
All user-facing strings are stored in `AppStrings` within `lib/providers/language_provider.dart`. 
*   Uses a simple key-value map for `en` and `vi`.
*   Supports parameter replacement (e.g., `{name}`).
*   Default fallback is always English.

## 4. Persistence with Hive
The game automatically saves after every significant action (roll, buy, upgrade).
*   Uses specific TypeAdapters for each model.
*   Handles backward compatibility with `defaultValue` in HiveFields.
*   The "Resume" feature on the Setup screen reads from the `current_match` key in the `game_save` box.
