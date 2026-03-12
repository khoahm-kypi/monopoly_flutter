# Monopoly Ant - Monopoly-Style Tabletop Game

[🇻🇳 Xem bản Tiếng Việt tại đây](README_vi.md)

A cross-platform board game developed with **Flutter** for mobile (iOS & Android). Monopoly Ant is designed for offline play, perfect for travel groups and families.

## 🚀 Features
*   **Multiplayer Pass & Play:** 2-4 players on a single device.
*   **Offline Mode:** No internet connection required.
*   **Dynamic Board Sizes:** Choose from Small, Medium, Large, or XLarge board configurations (MVP currently uses Medium).
*   **Localization:** Full support for **English** (default) and **Vietnamese**.
*   **Auto-Save & Resume:** Automatically saves your game progress, allowing you to pick up where you left off.
*   **Dynamic Gameplay:** Property purchases, house upgrades, tax collection, and chance cards.
*   **Bot Support:** Play with automated AI opponents.

## 🛠️ Technology Stack
*   **Frontend:** [Flutter](https://flutter.dev/) (SDK ^3.10.7)
*   **State Management:** [Riverpod](https://riverpod.dev/)
*   **Database:** [Hive](https://docs.hivedb.dev/) (for persistence)
*   **Animations:** [Flutter Animate](https://pub.dev/packages/flutter_animate)
*   **UID Generation:** [uuid](https://pub.dev/packages/uuid)

## 📂 Project Structure
*   `lib/models/`: Data models and Hive adapters.
*   `lib/providers/`: Business logic and state management.
*   `lib/screens/`: Main application screens (Setup, Game).
*   `lib/widgets/`: Reusable UI components (Board, Tiles, Player Panels, Logs).
*   `docs/`: Detailed project documentation (PRD, Technical Overview).

## 📖 Documentation
Detailed information can be found in the `docs/` folder:
*   [Product Requirements (PRD)](docs/prd.md)
*   [Technical Overview](docs/technical_overview.md)

## 🏗️ Getting Started

### Prerequisites
*   Flutter SDK installed.
*   Android Studio / Xcode (for mobile development).

### Installation
1. Clone the repository:
   ```bash
   git clone [repository-url]
   ```
2. Navigate to the project directory:
   ```bash
   cd Monopoly-Ant
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. Run the application:
   ```bash
   flutter run
   ```

## 📜 License
This project is for educational/personal use. Please refer to individual library licenses for third-party dependencies.
