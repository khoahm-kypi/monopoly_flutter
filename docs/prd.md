# Product Requirements Document (PRD) - MonoTravel (Offline)

## 1. Project Overview
**Project Name:** MonoTravel
**Description:** A Monopoly-style board game developed for mobile (iOS & Android) using Flutter.
**Core Objective:** Provide a fast, smooth offline entertainment experience for travel groups and children (ages 6-13). The game eliminates online elements entirely, focusing on same-device multiplayer (Pass & Play) and customizable board sizes to suit player time constraints.

## 2. Audience & Usage Context
*   **Users:** Children (6-13 years), friends/families traveling together.
*   **Context:** Playing on buses, planes, cafes, or hotel rooms (where internet might be absent or weak). Everyone gathers around one iPad/Tablet or passes around a phone.

## 3. Key Features (Functional Requirements)

### 3.1. Game Setup
Users configure the match before starting.
*   **Number of Players:** Choose 2, 3, or 4 players.
*   **Player Identification:** Enter names (max 10 characters) and select tokens (e.g., Car, Boat, Plane, Dog...).
*   **Board Size Configuration:** *This is the USP (Unique Selling Point).*

| Size | Tiles per Side | Total Tiles | Pace | Initial Money |
| :--- | :---: | :---: | :--- | :--- |
| **Small** | 6 | 20 | Very Fast (15-20m) | $1,000 |
| **Medium** | 8 | 28 | Medium (25-40m) | $1,500 |
| **Large** | 10 (Classic)| 36 | Long (45m - 1h) | $1,500 |
| **XLarge** | 12 | 44 | Very Long (>1h) | $2,000 |

*(Note: The 4 corners are fixed: GO - Jail - Free Parking - Go to Jail. Customizable tiles like Properties, Tax, and Chance are placed between corners).*

### 3.2. Core Gameplay (Pass & Play)
*   **Turns:**
    *   System notification: "TURN OF [PLAYER NAME] - Pass the device to [PLAYER NAME]".
    *   Player presses "ROLL DICE".
    *   Token moves automatically based on dice total with per-tile animations.
*   **Tile Interactions:**
    *   **Empty Property:** Pop-up for purchase (Name, Price, "Buy", "Skip"). *Rule simplification: No auctions to keep the pace fast.*
    *   **Owned Property:** System **automatically deducts** rent from the visitor and credits the owner. Notification (Toast/Popup): "You paid $50 rent to [Player B]".
    *   **Chance / Fortune:** Automatically flip a random card and apply effects (Add/Subtract money, Jail).
*   **Management & Construction:**
    *   "My Assets" button is always available.
    *   Displays owned properties grouped by color.
    *   If a full set is owned, "Build House" becomes active for immediate purchase.
*   **Bankruptcy:**
    *   When money < 0 and no assets left to sell, players are eliminated. Tokens disappear.
    *   Game ends when 1 survivor remains, or an "Early End" button shows (Highest net worth wins).

### 3.3. Offline Save/Load (Auto-Save)
*   **Auto-save:** Automatically save game state to local storage after every dice roll.
*   **Resume:** If an unfinished match exists, "Resume Game" appears on the Home screen.

## 4. UI/UX (Interface & Experience)
*   **Orientation:** Locked to **Landscape** for optimal board display.
*   **Layout:**
    *   *Center:* Square board, auto-scaling based on device and size (Small, Medium...).
    *   *Sides:* Avatars, names, and money for players. The active player has a glow effect.
*   **Kids-friendly:**
    *   Vibrant primary colors.
    *   Simple integer currency (e.g., $1,000) instead of complex decimals.
    *   Financial movement particles during payments.
*   **Audio:**
    *   Rolling dice sounds.
    *   "Ka-ching" for receiving money.
    *   Quick Mute/Unmute button on the main screen.

## 5. Technical Requirements (For Developers)

### 5.1. Tech Stack
*   **Framework:** Flutter (Dart).
*   **Local Storage:** `hive` (For saving configuration and state).
*   **State Management:** `Riverpod` (Recommended for complex board states).
*   **Animations:** `flutter_animate` and `TweenAnimationBuilder`.

### 5.2. Core Data Structure
The dynamic board requires an automated Generator logic.

```dart
class GameState {
  final int boardSizeEnum; 
  final List<Player> players;
  final int currentPlayerIndex;
  final List<Tile> boardTiles; 
}

class Tile {
  final String id;
  final String name;
  final TileType type; // PROPERTY, GO, CHANCE, TAX, JAIL...
  final int? colorValue; 
  final int price;
  String? ownerId;
  int houseCount;
}
```

### 5.3. Responsive UI
*   Use a custom Stack-based layout with mathematical coordinate calculations to draw tiles around the edges (instead of a default GridView).

## 6. Release Roadmap

### Phase 1: MVP (Minimum Viable Product)
*   Setup screen (2-4 players).
*   Fixed Medium board size (28 tiles).
*   Core loop: Roll -> Move -> Buy -> Pay.
*   Basic UI for phones and tablets.

### Phase 2: Dynamic Board & Auto-Save
*   Integrate size options (Small, Medium, Large, XLarge).
*   Implement map generation algorithm.
*   Auto-save and Resume offline using Hive.

### Phase 3: Polish & Kids Mode
*   Add House/Hotel construction.
*   Enhanced animations and sound effects.
*   Performance optimization for older devices.
